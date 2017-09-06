#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

#define ALT_AXI_FPGASLVS_OFST (0xC0000000) // axi_master
#define HW_FPGA_AXI_SPAN ( 0xFBFFFFFF-ALT_AXI_FPGASLVS_OFST+1 ) // Bridge span
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )

int ipow(int base, int exp);

//Seven Seg display: 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,-, .
uint8_t _seven_mask[]={
		0x3F, //0
		0x06, //1
		0x5B, //2
		0x4F, //3
		0x66, //4
		0x6D, //5
		0x7D, //6
		0x07, //7
		0x7F, //8
		0x6F, //9
		0x77, //A
		0x7c, //B
		0x39, //C
		0x5E, //D
		0x79, //E
		0x71, //F
		0x40, //-
		0x00};//

uint8_t d2ss(int value,int digit) //returns seven segment 'digit' configuration according entered 'value'
{
	uint8_t res=0xFF;
	if(digit<0)
	{
		if(value<0) res=_seven_mask[16];
		else res=_seven_mask[17];
	}
	else if(digit<100)
	{
		uint8_t n;
		if(value>0) n=(value%ipow(10,digit+1))/ipow(10,digit);
		else n=17;

		res=_seven_mask[n];
	}
	res=~res;
	return res;
}

uint8_t h2ss(int value,int digit) //returns seven segment 'digit' configuration according entered hexadecimal 'value'
{
	uint8_t res=0xFF;
	if(digit<0)
	{
		if(value<0) res=_seven_mask[16];
		else res=_seven_mask[17];
	}
	else if(digit<100)
	{
		uint8_t n;
		if(value>0) n=(value%ipow(10,digit+1))/ipow(10,digit);
		else n=17;

		res=_seven_mask[n];
	}
	res=~res;
	return res;
}

int main() {

	void *virtual_base,*h2f_virtual_base;
	int fd;
	int loop_count;
	int led_direction;
	int led_mask;
	void *h2p_lw_led_addr;
	void *h2p_lw_sw_addr;
	void *seven_seg_addr[6];
	void *r1_req,*r1_data_high,*r1_data_low,*r1_ack;
	void *r1_reset;
	void *r1_command;
	void *r1_v0x,*r1_v0y,*r1_v0z;
	void *r1_v1x,*r1_v1y,*r1_v1z;
	void *r1_v2x,*r1_v2y,*r1_v2z;
	void *r1_clip_rect0,*r1_clip_rect1;
	void *r1_tile0,*r1_tile1,*r1_depth_coef_a,*r1_depth_coef_b,*r1_depth_coef_c;
	void *r1_quad_buffer_addr_high,*r1_quad_buffer_addr_low;
	void *r1_status;

	//
	time_t t;
	srand((unsigned) time(&t));

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	h2p_lw_led_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LED_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_sw_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DIPSW_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[0]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[1]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_1_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[2]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_2_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[3]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_3_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[4]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_4_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	seven_seg_addr[5]=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SEVEN_SEG_5_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	alt_write_word(seven_seg_addr[0],d2ss(0,0));
	alt_write_word(seven_seg_addr[1],d2ss(0,0));
	alt_write_word(seven_seg_addr[2],d2ss(0,0));
	alt_write_word(seven_seg_addr[3],d2ss(0,0));
	alt_write_word(seven_seg_addr[4],d2ss(0,0));
	alt_write_word(seven_seg_addr[5],d2ss(0,0));

	//
	h2f_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd,ALT_AXI_FPGASLVS_OFST );
	if( h2f_virtual_base == MAP_FAILED ) {
		if( munmap( h2f_virtual_base, HW_FPGA_AXI_SPAN ) != 0 ) {
				printf( "ERROR: munmap() failed...\n" );
				close( fd );
				return( 1 );
		}
		printf( "ERROR: mmap() failed for h2f mapping...\n" );
		close( fd );
		return( 1 );
	}

	r1_reset=h2f_virtual_base + ( ( unsigned long  )( OGPU_RESET_BASE ));
	r1_req=h2f_virtual_base + ( ( unsigned long  )( OGPU_QUAD_STORE_REQ_BASE ));
	r1_data_high=h2f_virtual_base + ( ( unsigned long  )( OGPU_QUAD_STORE_DATA_HIGH_BASE ));
	r1_data_low=h2f_virtual_base + ( ( unsigned long  )( OGPU_QUAD_STORE_DATA_LOW_BASE ));
	r1_ack=h2f_virtual_base + ( ( unsigned long  )( OGPU_QUAD_STORE_ACK_BASE ));

	r1_command=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_COMMAND_BASE ));
	r1_v0x=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V0X_BASE ));
	r1_v0y=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V0Y_BASE ));
	r1_v0z=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V0Z_BASE ));
	r1_v1x=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V1X_BASE ));
	r1_v1y=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V1Y_BASE ));
	r1_v1z=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V1Z_BASE ));
	r1_v2x=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V2X_BASE ));
	r1_v2y=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V2Y_BASE ));
	r1_v2z=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_V2Z_BASE ));
	r1_clip_rect0=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_CLIP_RECT0_BASE ));
	r1_clip_rect1=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_CLIP_RECT1_BASE ));
	r1_tile0=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_TILE0_BASE ));
	r1_tile1=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_TILE1_BASE ));
	r1_depth_coef_a=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_DEPTH_COEF_A_BASE ));
	r1_depth_coef_b=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_DEPTH_COEF_B_BASE ));
	r1_depth_coef_c=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_DEPTH_COEF_C_BASE ));
	r1_quad_buffer_addr_high=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_QUAD_BUFFER_ADDR_HIGH_BASE ));
	r1_quad_buffer_addr_low=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_QUAD_BUFFER_ADDR_LOW_BASE ));
	r1_status=h2f_virtual_base + ( ( unsigned long  )( OGPU_RASTER_UNIT_STATUS_BASE ));

	uint8_t command=0xAA;
	uint16_t v0x=0,		v0y=0,		v0z=1;
	uint16_t v1x=1000,	v1y=0,		v1z=1;
	uint16_t v2x=0,	v2y=1000,		v2z=1;
	uint32_t clip_rect0,clip_rect1,tile0,tile1;
	uint16_t x0,y0,x1,y1;
	x0=(v0x<v1x?(v0x<v2x?v0x:v2x) : (v1x<v2x?v1x:v2x));
	y0=(v0y<v1y?(v0y<v2y?v0y:v2y) : (v1y<v2y?v1y:v2y));
	x1=(v0x>v1x?(v0x>v2x?v0x:v2x) : (v1x>v2x?v1x:v2x));
	y1=(v0y>v1y?(v0y>v2y?v0y:v2y) : (v1y>v2y?v1y:v2y));
	printf("clip_rect: p0(%d,%d) p1(%d,%d)\n",x0,y0,x1,y1);
	clip_rect0=(x0<<16)|(y0&0xFFFF);//x0|y0
	clip_rect1=(x1<<16)|(y1&0xFFFF);//x1|y1
	tile0=(0<<16)|(0&0xFFFF);//x0|y0 tile of 64x64 pixels
	tile1=(62<<16)|(62&0xFFFF);//x1|y1
	printf("tile: p0(%x) p1(%x)\n",tile0,tile1);

	printf("status: %x\n",alt_read_word(r1_status));
	alt_write_word(r1_v0x,v0x); alt_write_word(r1_v0y,v0y); alt_write_word(r1_v0z,v0z);
	alt_write_word(r1_v1x,v1x); alt_write_word(r1_v1y,v1y); alt_write_word(r1_v1z,v1z);
	alt_write_word(r1_v2x,v2x); alt_write_word(r1_v2y,v2y); alt_write_word(r1_v2z,v2z);
	alt_write_word(r1_clip_rect0,clip_rect0); alt_write_word(r1_clip_rect1,clip_rect1);
	alt_write_word(r1_tile0,tile0); alt_write_word(r1_tile1,tile1);
	alt_write_word(r1_depth_coef_a,0);
	alt_write_word(r1_depth_coef_b,0);
	alt_write_word(r1_depth_coef_c,0);
	alt_write_word(r1_quad_buffer_addr_high,0); alt_write_word(r1_quad_buffer_addr_low,0);
	alt_write_word(r1_command,command);


	int i=0;
	uint32_t s,r,dataH,dataL,ibuf;
	uint64_t mem_buf[8192];

	alt_write_word(r1_reset,0); // reset gpu(active low)
	usleep(1000);
	alt_write_word(r1_reset,1); // active gpu

	s=alt_read_word(r1_status);
	if((s&1)==1)
	{
		command=0xA5;
		alt_write_word(r1_command,command);
		while((alt_read_word(r1_status)&1)==1);
	}
	ibuf=0;
	command=0xAA;
	alt_write_word(r1_command,command);
	s=alt_read_word(r1_status);
	while((s&1)==0) //while DONE bit is zero
	{
		s=alt_read_word(r1_status);
		r=alt_read_word(r1_req);
		if(r)
		{
			dataH=alt_read_word(r1_data_high);
			dataL=alt_read_word(r1_data_low);
			alt_write_word(r1_ack,1);
			//usleep(10000);
			while(alt_read_word(r1_req)); // while req signal is high
			alt_write_word(r1_ack,0);
			mem_buf[ibuf++]=(uint64_t)((((uint64_t)dataH)<<32)|(dataL));
		}
		if(ibuf>=65536) break;
	}
	s=alt_read_word(r1_status);

	command=0xA5;
	alt_write_word(r1_command,command);
	i=0;
	do
	{
		s=alt_read_word(r1_status);
		printf("status(prepare) (%d us): %x\n",i,s);
		usleep(i);
		i+=100;
	}while((s&1)!=0); //while DONE bit is one

	FILE *file=fopen("mem_o8.txt","w");
	assert(file!=NULL);

	for(i=0;i<ibuf;i+=1)
	{
		fprintf(file,"%lx:\t\t%x%x\n",(long unsigned)i*8,(uint32_t)(mem_buf[i]>>32),(uint32_t)(mem_buf[i]&0xFFFFFFFF));
		fprintf(file,"quad %d: (%d,%d)\tmask(%d%d%d%d)\n",i+1,(uint16_t)(mem_buf[i]>>48),
				(uint16_t)(mem_buf[i]>>32),
				(uint8_t)(mem_buf[i]>>3)&1,
				(uint8_t)(mem_buf[i]>>2)&1,
				(uint8_t)(mem_buf[i]>>1)&1,
				(uint8_t)(mem_buf[i])&1);
	}

	fclose(file);

	// toggle the LEDs a bit

	loop_count = 0;
	led_mask = 0x01;
	led_direction = 0; // 0: left to right direction
	while( loop_count < 60 ) {

		int sw = alt_read_hword(h2p_lw_sw_addr) & 0x3FF;
			static unsigned f_counter = 0;

			f_counter++;

			if(sw&4) // information ON
			{
				static time_t t0=0;
				double seconds = difftime(time(NULL),t0);
				static unsigned fps=0;
				if(seconds>2)
				{
					fps=(unsigned)(f_counter/seconds*10000);
					t0=time(NULL);

					if(sw&2) //Total frame number after switching to this mode
					{
						alt_write_word(seven_seg_addr[0],d2ss(f_counter,0));
						alt_write_word(seven_seg_addr[1],d2ss(f_counter,1));
						alt_write_word(seven_seg_addr[2],h2ss(f_counter,2));
						alt_write_word(seven_seg_addr[3],h2ss(f_counter,3));
						alt_write_word(seven_seg_addr[4],h2ss(f_counter,4));
						alt_write_word(seven_seg_addr[5],h2ss(f_counter,5));
					}
					else //FPS
					{

						alt_write_word(seven_seg_addr[0],d2ss(fps,0));
						alt_write_word(seven_seg_addr[1],d2ss(fps,1));
						alt_write_word(seven_seg_addr[2],h2ss(fps,2));
						alt_write_word(seven_seg_addr[3],h2ss(-1,0));
						alt_write_word(seven_seg_addr[4],h2ss(fps,3));
						alt_write_word(seven_seg_addr[5],h2ss(fps,4));
						f_counter=0;
					}
				}

				// control led
				if(sw&1) *(uint32_t *)h2p_lw_led_addr = led_mask;
				else *(uint32_t *)h2p_lw_led_addr = ~led_mask;

				// update led mask
				if (led_direction == 0){
					led_mask <<= 1;
					if (led_mask == (0x01 << (LED_PIO_DATA_WIDTH-1)))
						 led_direction = 1;
				}else{
					led_mask >>= 1;
					if (led_mask == 0x01){
						led_direction = 0;
					}
				}
			}
//
//		// control led
//		//*(uint32_t *)h2p_lw_led_addr = led_mask;
//		led_mask = alt_read_hword(h2p_lw_sw_addr) & 0x3FF;
//		led_mask<<=10;
//		if(led_direction>=0) led_mask>>=led_direction;
//		else led_mask>>=(-led_direction);
//
//		// wait 100ms
		usleep( 300*1000 );
//
//		// update led mask
//		led_direction++;
//		if(led_direction>19)
//		{
//			led_direction=-19;
//			loop_count++;
//		}
//
//		unsigned r = rand() % 0xFFFF;
//
//		if(alt_read_hword(h2p_lw_sw_addr) & 1<<9)
//		{
//			alt_write_word(h2p_lw_led_addr,led_mask);
//			alt_write_word(seven_seg_addr[0],d2ss(loop_count,0));
//			alt_write_word(seven_seg_addr[1],d2ss(loop_count,1));
//			alt_write_word(seven_seg_addr[2],h2ss(r,0));
//			alt_write_word(seven_seg_addr[3],h2ss(r,1));
//			alt_write_word(seven_seg_addr[4],h2ss(r,2));
//			alt_write_word(seven_seg_addr[5],h2ss(r,3));
//		}
//		else
//		{
//			alt_write_word(h2p_lw_led_addr,0);
//			alt_write_word(seven_seg_addr[0],d2ss(-1,0));
//			alt_write_word(seven_seg_addr[1],d2ss(-1,0));
//			alt_write_word(seven_seg_addr[2],h2ss(-1,0));
//			alt_write_word(seven_seg_addr[3],h2ss(-1,0));
//			alt_write_word(seven_seg_addr[4],h2ss(-1,0));
//			alt_write_word(seven_seg_addr[5],h2ss(-1,0));
//			usleep(1000 * 1000);
//		}
		
	} // while
	*(uint32_t *)h2p_lw_led_addr = 0;
	alt_write_word(seven_seg_addr[0],d2ss(0,-1));
	alt_write_word(seven_seg_addr[1],d2ss(0,-1));
	alt_write_word(seven_seg_addr[2],d2ss(0,-1));
	alt_write_word(seven_seg_addr[3],d2ss(0,-1));
	alt_write_word(seven_seg_addr[4],d2ss(0,-1));
	alt_write_word(seven_seg_addr[5],d2ss(0,-1));
	

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		if( munmap( h2f_virtual_base, HW_FPGA_AXI_SPAN ) != 0 ) {
				printf( "ERROR: h2f munmap() failed...\n" );
				close( fd );
				return( 1 );
		}
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	else
	{
		if( munmap( h2f_virtual_base, HW_FPGA_AXI_SPAN ) != 0 ) {
				printf( "ERROR: h2f munmap() failed...\n" );
				close( fd );
				return( 1 );
		}
	}

	close( fd );

	return( 0 );
}

int ipow(int base, int exp)
{
    int result = 1;
    while (exp)
    {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}
