
#include "connector.h"
class ARQTx;
enum ARQStatus {IDLE,SENT,ACKED,RTX,DROP};

class ARQHandler : public Handler {
public:
    ARQHandler(ARQTx& arq) : arq_tx_(arq) {};
    void handle(Event*);
private:
    ARQTx& arq_tx_;
};

class ARQTx : public Connector {
public:
    ARQTx();
    void recv(Packet*, Handler*);
    void nack(Packet*);
    void ack();
    void resume();
  protected:
    ARQHandler arqh_;
    Handler* handler_;
    Packet* pkt_;
    ARQStatus status_;
    int blocked_;
    int retry_limit_;
    int num_rtxs_;
};

class ARQRx : public Connector {
public:
    ARQRx()  {arq_tx_=0; };
    int command(int argc, const char*const* argv);
    virtual void recv(Packet*, Handler*);
  protected:
    ARQTx* arq_tx_;
    Packet *pkt_;       // for delay
    Handler *handler_;  // for delay
    double delay_;      // for delay
    Event event_;       // for delay
};

class ARQAcker : public ARQRx {
public:
    ARQAcker() {};
    //virtual void recv(Packet*, Handler*);  // for NO delay
    virtual void handle(Event*);             // for delay
};

class ARQNacker : public ARQRx {
public:
    ARQNacker() {};
    //virtual void recv(Packet*, Handler*);  // for NO delay
    virtual void handle(Event*);             // for delay
};
