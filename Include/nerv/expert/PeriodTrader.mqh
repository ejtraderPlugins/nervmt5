#include <nerv/core.mqh>
#include <nerv/expert/Trader.mqh>

/*
Class: nvPeriodTrader

Simple class based on the Trader implementation and addition the notion
of bar handling.

*/
class nvPeriodTrader : public nvTrader
{
protected:
  ENUM_TIMEFRAMES _period;

public:
  /*
    Class constructor.
  */
  nvPeriodTrader(const nvSecurity& sec, ENUM_TIMEFRAMES period) : nvTrader(sec)
  {
    _period = period;
  }

  /*
    Copy constructor
  */
  nvPeriodTrader(const nvPeriodTrader& rhs) : nvTrader(rhs._security)
  {
    this = rhs;
  }

  /*
    assignment operator
  */
  void operator=(const nvPeriodTrader& rhs)
  {
    THROW("No copy assignment.")
  }

  /*
    Class destructor.
  */
  ~nvPeriodTrader()
  {
    // No op.
  }

  /*
  Function: onTick
  
  Method called on each tick event to decide is a new bar should be handled.
  */
  void onTick()
  {
    if(Bars(_security.getSymbol(),_period)<60) // if total bars is less than 60 bars
    {
      logDEBUG("Not enough bars in nvPeriodTrader");
      return;
    }

    static datetime Old_Time;
    datetime New_Time[1];
    bool IsNewBar=false;

    // copying the last bar time to the element New_Time[0]
    int copied=CopyTime(_security.getSymbol(),_period,0,1,New_Time);
    CHECK(copied==1,"Invalid result for CopyTime operation: "<<copied);

    if(Old_Time!=New_Time[0]) // if old time isn't equal to new bar time
    {
      IsNewBar=true;   // if it isn't a first call, the new bar has appeared
      // logDEBUG("Handling new bar at time "<<New_Time[0]<<" old time was: "<<Old_Time);
      Old_Time=New_Time[0];            // saving bar time  
      handleBar();    
    }

    // We call the handleTick() method afterward:
    handleTick();    
  }
  
  /*
  Function: handleBar
  
  Method called to perform the trader operation when a new bar is received.
  Note that this default implementation will throw an error if called.
  */
  virtual void handleBar()
  {
    NO_IMPL(); 
  }
  

  /*
  Function: handleTick
  
  Method used to handle a tick (after handleBar was called if applicable).
  The default implementation does nothing.
  */
  virtual void handleTick()
  {
    // No op.
  }
  
};
