
#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#define NF10_IOCTL_CMD_READ_STAT (SIOCDEVPRIVATE+0)
#define NF10_IOCTL_CMD_WRITE_REG (SIOCDEVPRIVATE+1)
#define NF10_IOCTL_CMD_READ_REG (SIOCDEVPRIVATE+2)
#define MASK_VALUE 0xffffffff
#define ERROR_CODE 0xdeadbeef

uint32_t regread(uint32_t addr);
int regwrite(uint32_t addr, uint32_t val);
int regread_expect(uint32_t addr, uint32_t expval);

uint32_t regread(uint32_t addr)
{
        uint64_t v;
        uint32_t val;
	int f;

  	f = open("/dev/nf10", O_RDWR);

  	if(f < 0){
        	printf("ERROR opening device /dev/nf10\n");
        return ERROR_CODE;
  	}

        v = addr;
        if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
                perror("Call: nf10 ioctl failed\n");
                return ERROR_CODE;
        }

        val = v & MASK_VALUE;
	
	close(f);
        return val;
}


int regread_expect(uint32_t addr, uint32_t expval)
{
        uint64_t v;
        uint32_t val;
        int f;

        f = open("/dev/nf10", O_RDWR);

        if(f < 0){
                printf("ERROR opening device /dev/nf10\n");
        return ERROR_CODE;
        }

        v = addr;
        if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
                perror("Call: nf10 ioctl failed\n");
                return ERROR_CODE;
        }

        val = v & MASK_VALUE;
         
 	if(val != expval){ 
		printf("Call: regread_expect failed!!! address= 0x%x \t returned value= %d \t expected value= %d\n\n",addr,val,expval);
       	return 0;
		}
	else
	return 1;
	
close(f);
        
}

int regwrite(uint32_t addr, uint32_t val)
{

        uint64_t v;
	int f;

	f = open("/dev/nf10", O_RDWR);

  	if(f < 0){
        	printf("ERROR opening device /dev/nf10\n");
        return ERROR_CODE;
  	}



        v = addr;
        v=(v<<32)+val;

        if(ioctl(f, NF10_IOCTL_CMD_WRITE_REG, v) < 0){
                perror("Call: nf10 ioctl failed\n");
                return ERROR_CODE;
        }

	close(f);

        return 0;
}

