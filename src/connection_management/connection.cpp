#include "connection.h"

const string Connection::R_IP   = "faridarbai.ddns.net";
const string Connection::R_PORT = "25255";
const int Connection::BUFFER_SIZE = 1048576;
const char Connection::END_DELIM = '~';
const char Connection::SIGNATURE_DELIM = '#';
const int Connection::SERVER_EXCHANGE_SIZE = 390;

Connection::Connection() {
#ifdef _WIN32
    WSADATA wsa_data;
    int     wsa_result = WSAStartup(MAKEWORD(2,2),&wsa_data);
    bool conn_err = false;
    bool close_socket = false;
    std::string err_msg = "";

    struct addrinfo* result =   nullptr;
    struct addrinfo* ptr    =   nullptr;
    struct addrinfo hints;

    SOCKET client_socket = INVALID_SOCKET;;

    if(wsa_result!=0){
        conn_err = true;
        err_msg = "Local Error : Could not initialize WSAStartup. Your local machine is not allowing "
                  "the app to use one of its sockets in order to connect to the server, please check your "
                  "firewall rules since we need to open a connection to remote port " + std::string(R_PORT)+ ".\n"
                  "If the problem persists please report admin Farid since we are constantly working "
                  "in order to make this app as much portable as we can.";

    }
    else{



        ZeroMemory(&hints,sizeof(hints));

        hints.ai_family     =   AF_INET;
        hints.ai_socktype   =   SOCK_STREAM;
        hints.ai_protocol   =   IPPROTO_TCP;

        int server_availability = getaddrinfo(R_IP.c_str(),R_PORT.c_str(),&hints,&result);

        if(server_availability!=0){
            conn_err = true;
            err_msg = "Remote error : Server\'s IP address could not be resolved "
                       "due to a DDNS server (no-ip.com) failure.\n"
                       "We can not solve this issue since we haven't access to their infrastructure but "
                       "please report admin Farid this issue in order to find a quick solution.\n";
        }
        else{


            ptr = result;

            client_socket = ::socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);

            if(client_socket==INVALID_SOCKET){
                conn_err = true;
                err_msg = "Local error : There was an issue retrieving the socket whose file descriptor matches "
                          "" + stda::to_string(WSAGetLastError()) + " due to a strange bheavior of your system's network stack. Please "
                          "check your networking setup with batch 'netsh' command if you're experienced with "
                          "windows networking or report admin Farid this issue in order to find a customized "
                          "solution which solves your networking setup issue.";
            }
            else{
                int conn_result = connect(client_socket, ptr->ai_addr, (int)ptr->ai_addrlen);

                if(conn_result==SOCKET_ERROR){
                    conn_err = true;
                    close_socket = true;
                    err_msg = "Remote error : Connection against server timed out. Following reasons might be possible : \n"
                              "1. There is a firewall in your network or local machine who is filtering TCP packets whose "
                              "destination port is" + std::string(R_PORT) + "\n"
                              "2. Server's internet connectivity went down due to ISP ONO's network failure.\n"
                              "3. Server has gone down due to an electrical failure.\n"
                              "If you're sure that the issue doen't match the local firewall condition then we please you to "
                              "report admin's Farid the issue in order to quickly check network and server' availability";
                }
                else{

                }

                freeaddrinfo(result);
            }
        }
    }

    if(close_socket){
        this->close();
    }

    if(conn_err){
        this->activateConnErr();
        this->setErrMsg(err_msg);
        if(!close_socket){
            WSACleanup();
        }
    }
    else{
        this->setSocket(client_socket);
    }

#else
    int client_socket;
    struct sockaddr_in serv_addr;
    struct hostent* server;

    client_socket = ::socket(AF_INET,SOCK_STREAM,0);

    const char* server_name = R_IP.c_str();
    int server_port = atoi(R_PORT.c_str());

    server = gethostbyname(server_name);

    bzero((char*)&serv_addr,sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;

    bcopy((char*)server->h_addr,
          (char*)&serv_addr.sin_addr.s_addr,
          server->h_length);

    serv_addr.sin_port = htons(server_port);
    connect(client_socket,
            (struct sockaddr*)&serv_addr,
            sizeof(serv_addr));

    this->setSocket(client_socket);

#endif
    // INIT THE SESSION KEYS AND IVS
    this->initEngine();
}

Connection::~Connection() {
}

void Connection::close(){
    int socket = this->getSocket();
#ifdef _WIN32
    shutdown(socket,SD_BOTH);
    ::closesocket(socket);
    WSACleanup();
#else
    shutdown(socket,SHUT_RDWR);
#endif
}

void Connection::setSocket(int socket){
    this->socket = socket;
}

int Connection::getSocket() const{
    return this->socket;
}

void Connection::setErrMsg(string err_msg){
    this->err_msg = err_msg;
}

string Connection::getErrMsg(){
    return this->err_msg;
}
void Connection::activateConnErr(){
    this->conn_err = true;
}

bool Connection::err(){
    return this->conn_err;
}

void Connection::sendPM(ProtocolMessage* pm){
    int client_socket = this->getSocket();
    string str_send;
    const char* buffer_encr;
    int encr_len;
    ProtocolMessage::MessageType m_type = ProtocolMessage::getMessageTypeOf(pm);

    switch(m_type){
        case(ProtocolMessage::MessageType::msg):{
            ((PM_msg*)pm)->encode();
            break;
        }
        case(ProtocolMessage::MessageType::updateStatus):{
            ((PM_updateStatus*)pm)->encode();
            break;
        }
        default:{
            break;
        }
    }

    str_send = pm->toString();

    this->clearDelims(str_send);

    str_send = encryption_engine.encrypt(str_send) + Connection::END_DELIM;

    buffer_encr = str_send.c_str();
    encr_len = str_send.length();

    send(client_socket, buffer_encr, encr_len, 0);
}

ProtocolMessage* Connection::recvPM(){
    int client_socket =	this->getSocket();
    char* buffer =	nullptr;

    buffer = (char*)malloc(Connection::BUFFER_SIZE*sizeof(char));

    char* sub_buffer = buffer;
    int offset = 0;
    bool finished_recv = false;
    ssize_t n_bytes_chunk;
    ssize_t n_bytes_data;
    int sub_buffer_size;
    int pos_delim;
    bool found_delim = false;
    char* ptr_delim;
    int buffer_size = Connection::BUFFER_SIZE;

    while(!finished_recv){
        sub_buffer_size = buffer_size - offset;

        n_bytes_chunk = recv(client_socket, sub_buffer, sub_buffer_size, MSG_PEEK);

        if(n_bytes_chunk>0){
            ptr_delim = strchr(sub_buffer,Connection::END_DELIM);

            if(ptr_delim==nullptr){
                found_delim = false;
            }
            else{
                pos_delim = (int)(ptr_delim - sub_buffer);
                found_delim = true;
            }

            if(!found_delim){
                recv(client_socket, sub_buffer, n_bytes_chunk, 0);

                offset += n_bytes_chunk;

                if(offset==buffer_size){
                    buffer_size *= 2;
                    buffer = (char*)realloc(buffer,buffer_size);
                    for(int i=offset; i<buffer_size; i++){
                        buffer[i] = '\0';
                    }
                }

                sub_buffer = &buffer[offset];

            }
            else{
                recv(client_socket, sub_buffer, (pos_delim+1), 0);
                n_bytes_data = offset + pos_delim + 1;
                finished_recv = true;
            }
        }
        else{
            finished_recv = true;
            n_bytes_data = n_bytes_chunk;
        }
    }

    ProtocolMessage* pm;

    if(n_bytes_data>0){
        buffer[n_bytes_data-1] = '\0';
        string str_recv = string(buffer);
        string signature = Connection::getSignature(str_recv);
        string payload = Connection::clearSignature(str_recv);
        bool signature_is_correct = PublicEngine::verifySignature(payload,signature);

        if(signature_is_correct){
            payload = this->encryption_engine.decrypt(payload);

            pm = ProtocolMessage::decode(payload);
            ProtocolMessage::MessageType m_type = ProtocolMessage::getMessageTypeOf(pm);

            switch(m_type){
                case(ProtocolMessage::MessageType::msg):{
                    ((PM_msg*)pm)->decode();
                    break;
                }
                case(ProtocolMessage::MessageType::updateStatus):{
                    ((PM_updateStatus*)pm)->decode();
                    break;
                }
                case(ProtocolMessage::MessageType::addContactCom):{
                    ((PM_addContactCom*)pm)->decode();
                    break;
                }
                case(ProtocolMessage::MessageType::addContactRep):{
                    ((PM_addContactRep*)pm)->decode();
                    break;
                }
                default:{
                    break;
                }
            }
        }

    }
    else{
        pm = nullptr;
        //Client closed connection
    }

    free(buffer);

    return pm;
}

string Connection::getSignature(const string& signed_message){
    int pos_delim = signed_message.find(Connection::SIGNATURE_DELIM);
    string signature = signed_message.substr(pos_delim+1);
    return signature;
}

string Connection::clearSignature(const string& signed_message){
    int pos_delim = signed_message.find(Connection::SIGNATURE_DELIM);
    string payload = signed_message.substr(0,pos_delim);
    return payload;
}

void Connection::clearDelims(string& orig){
    orig.erase(std::remove(orig.begin(), orig.end(), '\n'), orig.end());
    orig.erase(std::remove(orig.begin(), orig.end(), '\r'), orig.end());
}



void Connection::initEngine(){
    unsigned int seed;
    string c_key_token;
    string c_iv_token;
    string c_token;
    string s_key_token;
    string s_iv_token;
    string c_key_hi;
    string c_key_lo;
    string s_key_hi;
    string s_key_lo;
    string c_iv_hi;
    string c_iv_lo;
    string s_iv_hi;
    string s_iv_lo;
    int key_length = SymmetricEngine::KEY_LENGTH;
    int half = key_length/2;
    string client_exchange;
    const char* buffer_send;
    int send_len;
    int client_socket = this->getSocket();
    int n_bytes_recv;
    int n_bytes_recv_tot;
    char buffer_recv[Connection::SERVER_EXCHANGE_SIZE];
    char* sub_buffer;
    int sub_len;
    string server_response;
    string signature;
    string payload;
    string server_exchange;
    bool signature_is_correct;
    string key_send;
    string key_recv;
    string iv_send;
    string iv_recv;

    // 1. Generate the random token and send it to the server
    seed = Connection::generateSeed();
    srand(seed);

    c_key_token = Connection::generateRandomString(key_length);
    c_iv_token = Connection::generateRandomString(key_length);

    c_key_hi = c_key_token.substr(0,half);
    c_key_lo = c_key_token.substr(half,half);
    c_iv_hi = c_iv_token.substr(0,half);
    c_iv_lo = c_iv_token.substr(half,half);

    c_token = c_key_token + c_iv_token;

    client_exchange = PublicEngine::encrypt(c_token) + Connection::END_DELIM;

    buffer_send = client_exchange.c_str();
    send_len = client_exchange.length();

    send(client_socket, buffer_send, send_len, 0);

    // 2. Recv random token
    n_bytes_recv = 0;
    n_bytes_recv_tot = 0;
    bool conn_error;
    bool finished_exchange;

    do{
        sub_buffer = &buffer_recv[n_bytes_recv_tot];
        sub_len = Connection::SERVER_EXCHANGE_SIZE - n_bytes_recv_tot;

        n_bytes_recv = (int)recv(client_socket,sub_buffer,sub_len,0);

        n_bytes_recv_tot += (int)n_bytes_recv;

        conn_error = (n_bytes_recv == 0);
        finished_exchange = (n_bytes_recv_tot == Connection::SERVER_EXCHANGE_SIZE);

    }while((!finished_exchange)&&(!conn_error));

    printf("Recibidos %d bytes\n", n_bytes_recv);
    server_response = string(buffer_recv,(n_bytes_recv_tot-1));
    printf("Recibidos %d bytes reales\n", server_response.length());

    signature = Connection::getSignature(server_response);
    payload = Connection::clearSignature(server_response);
    signature_is_correct = PublicEngine::verifySignature(payload,signature);

    this->encryption_engine.init(c_key_token,c_iv_token,c_key_token,c_iv_token);
    server_exchange = this->encryption_engine.decrypt(payload);
    printf("El token del server mide %d\n", server_exchange.length());

    if(signature_is_correct){
        printf("La firma es correcta\n");
        // 3. Set session keys
        s_key_token = server_exchange.substr(0,key_length);         printf("El key del server mide %d\n", s_key_token.length());
        s_iv_token = server_exchange.substr(key_length,key_length); printf("El iv del server mide %d\n", s_iv_token.length());

        s_key_hi = s_key_token.substr(0,half);
        s_key_lo = s_key_token.substr(half,half);
        s_iv_hi = s_iv_token.substr(0,half);
        s_iv_lo = s_iv_token.substr(half,half);

        key_send = c_key_hi + s_key_lo;
        key_recv = s_key_hi + c_key_lo;

        iv_send = c_iv_hi + s_iv_lo;
        iv_recv = s_iv_hi + c_iv_lo;

        this->encryption_engine.init(key_send,iv_send,key_recv,iv_recv);
    }
    else{
        printf("La firma es incorrecta\n");
        // handle unreliable server
    }
}

string Connection::generateRandomString(int length){
    char* str_c = (char*)malloc(length*sizeof(char)+1);
    string str;
    int rand_int;
    char rand_char;

    for(int i=0; i<length; i++){
        do{
            rand_int = (std::rand()%256);
            rand_char = (char)rand_int;
        }while((rand_char=='\0')||(rand_char==SymmetricEngine::PAD_TOKEN));

        str_c[i] = (char)rand_int;
    }

    str_c[length] = '\0';

    str = string(str_c);
    free(str_c);
    return str;
}


unsigned int Connection::generateSeed(){
    auto time = std::chrono::system_clock::now();
    auto since_epoch = time.time_since_epoch();
    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(since_epoch);
    long long now = micros.count();
    long long one_second = 1000000;
    long long now_useconds = (now%one_second);
    unsigned int usec = (unsigned int)(now_useconds);
    unsigned int pid;
    unsigned int seed;

#ifdef _WIN32
    pid = (unsigned int)GetCurrentProcessId();
#else
    pid = (unsigned int)getpid();
#endif
    usec = usec & 0x0FFFFF;
    pid = pid & 0x0FFF;

    seed = (pid << 20) | (usec);

    return seed;
}













































