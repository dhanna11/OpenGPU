OpenGPU is an Open Source Hardware Graphics Processing Unit. Its main objective is to be a complete development framework for graphics and general processing(GPGPU).
The current implementation is synthesizable and runs in a Terasic DE1-SoC board. It has an Altera Cyclone V with a FPGA and an ARM single core processor in the same chip. Most of the processing occurs on top of a Linux environment, passing the graphic pipeline to the implemented rasterizer, returning to software processing and showing any OpenGL application on a VGA screen.
Next challenges are stabilish a better memory manager, a shader processing system and a framework for fixed functions like data compression and video coding.
Research and specific applications are also welcome... Feel free to contribute or even fork this repository!

Original author: Fabrício Ribeiro Toloczko
Special thanks to:
    -University of São Paulo;
    -CITI-USP;
    -Professor Marcelo Zuffo.
Contributors: Thiago Luqueta
