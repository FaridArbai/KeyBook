#ifndef REQUESTINGFRAME_H
#define REQUESTINGFRAME_H

#include "src/connection_management/requesthandler.h"

class RequestingFrame{
public:
    RequestingFrame();

    RequestingFrame(RequestHandler* request_handler);

    void setRequestHandler(RequestHandler* request_handler);
    RequestHandler* getRequestHandler();

protected:
    RequestHandler* request_handler;
};

#endif // REQUESTINGFRAME_H
