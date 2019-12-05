#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"
#include <fstream>
#include <vector> 

enum SYS_CALL{
  PRINT_B = 0x04,
  PRINT_MEM = 0x03,
  READ_B = 0x07,
  READ_MEM = 0x02,
  PRINT_STR = 0x01,
  READ_STR = 0x08,
  LOAD_EXEC = 0x05,
  PROCESS_EXIT = 0x09,
  SET_QUANTUM = 0x06,
  PRINT_WHOLE = 0x0a,
  RAND_INT    = 12,
  WAIT        = 13,
  SIGNAL      = 14 , 
  INSERT_MEM  = 15,
  REMOVE_MEM    = 16,
  SET_MUTEX_SMFR  = 17
};


class GTUOS{  
 public:
  /*
   * Constructor and destructor are written
   * for file open,close processing
   */
  GTUOS();
  ~GTUOS();

  uint64_t handleCall(CPU8080  & cpu);
  uint64_t sysPrintB(CPU8080 & cpu);
  uint64_t sysPrintMem(CPU8080 & cpu);
  uint64_t sysReadB(CPU8080 & cpu);
  uint64_t sysReadMem(CPU8080 & cpu);
  uint64_t sysPrintStr(CPU8080 & cpu);
  uint64_t sysReadStr(CPU8080 & cpu);
  uint64_t loadExec(CPU8080& cpu);
  uint64_t processExit(CPU8080& cpu);
  uint64_t setQuantum(CPU8080& cpu);  
  uint64_t printWhole(CPU8080& cpu);
  uint64_t rand_Int(CPU8080& cpu);		
  uint64_t wait(CPU8080& cpu);	
  uint64_t signal(CPU8080& cpu);
  uint64_t insert_Mem(CPU8080& cpu);
  uint64_t remove_Mem(CPU8080& cpu);
  uint64_t set_Mutex_Semaphore(CPU8080& cpu);
	
 private:
  /*These are used for file processing*/
  std::ofstream localList;
  std::ofstream mailBox;
  int message_box_start  = 2000 ;      // Initial message box address
  int message_box_lenght = 49;         // Message box lenght 
  int condition_veriables_lenght = 3;  // Condition veriables lenght	       			
  bool idOne = false;
  std::vector<int> wideList; 
};

#endif
