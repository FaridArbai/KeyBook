#include "requestingframe.h"

RequestingFrame::RequestingFrame(){

}

RequestingFrame::RequestingFrame(RequestHandler* request_handler){
    this->setRequestHandler(request_handler);
}

void RequestingFrame::setRequestHandler(RequestHandler* request_handler){
    this->request_handler = request_handler;
}
