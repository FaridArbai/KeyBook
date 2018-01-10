#include "Connection.h"

Connection::Connection() {
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

        int server_availability = getaddrinfo(R_IP,R_PORT,&hints,&result);

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
                          "" + std::to_string(WSAGetLastError()) + " due to a strange bheavior of your system's network stack. Please "
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
}

Connection::~Connection() {
}

void Connection::close(){
    int socket = this->getSocket();
    shutdown(socket,SD_BOTH);
    ::closesocket(socket);
    WSACleanup();
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
    string str_send = pm->toString();
    const char* buffer = str_send.c_str();
    int util = str_send.length();

    send(client_socket, buffer, util, 0);

}

ProtocolMessage* Connection::recvPM(){
    int client_socket =	this->getSocket();
    char* buffer =	nullptr;

    buffer = (char*)malloc(Connection::BUFFER_SIZE*sizeof(char));

    for(int i=0; i<Connection::BUFFER_SIZE; i++){
        buffer[i] = '\0';
    }

    char* sub_buffer = buffer;
    int offset = 0;
    bool finished_recv = false;
    ssize_t n_bytes_chunk;
    ssize_t n_bytes_data;
    int sub_buffer_size;
    int pos_delim;
    bool found_delim = false;
    char* ptr_delim;

    while(!finished_recv){
        sub_buffer_size = Connection::BUFFER_SIZE - offset;

        n_bytes_chunk = recv(client_socket, sub_buffer, sub_buffer_size, MSG_PEEK);

        if(n_bytes_chunk>0){
            ptr_delim = strchr(sub_buffer,'\n');

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
    string str_recv;

    if(n_bytes_data>0){
        str_recv = string(buffer,n_bytes_data);

        str_recv.erase(std::remove(str_recv.begin(), str_recv.end(), '\n'), str_recv.end());
        str_recv.erase(std::remove(str_recv.begin(), str_recv.end(), '\r'), str_recv.end());

        pm = ProtocolMessage::decode(str_recv);

        ProtocolMessage::MessageType m_type = ProtocolMessage::getMessageTypeOf(pm);

    }
    else{
        pm = nullptr;
        //Client closed connection
    }

    free(buffer);

    return pm;
}
