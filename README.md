OpenGPU is an Open Source Hardware Graphics Processing Unit. Its main objective is to be a complete development framework for graphics and general processing(GPGPU).

The current implementation is synthesizable and runs in a Terasic DE1 SoC board, which has an Altera Cyclone V embedding a FPGA and an ARM single core processor in the same chip. Most of the processing occurs on top of a Linux environment, passing the graphic pipeline to the implemented rasterizer, returning to software processing and showing any OpenGL application on a VGA screen.

Next challenges are stabilish a better memory manager, a shader processing system and a framework for fixed functions like data compression and video coding.

Research and specific applications are also welcome... Feel free to contribute or even fork this repository! Remember to tell me you made a contribution, then I can add you to the following contributors list.

# Authoring
###### Original author
Fabrício Ribeiro Toloczko

###### Institutions
* University of São Paulo
* LSI-USP
* CITI-USP
* Polytechnic School of University of São Paulo

###### Special thanks
Professor Marcelo Zuffo as counselor and advisor.

###### Contributors
Thiago Luqueta - DE1 SoC FPGA preparation

# Licensing
OpenGPU is licensed under Apache 2.0 license conditions.

It is available in file LICENSE.txt. Read it before use any part of OpenGPU's code.

# How it works
OpenGPU is simple today. It runs all graphic and non graphic pipeline over Mesa3D software stack. The rasterization process, excluding depth test, is done sending triangle data to FPGA implemented rasterizer and getting the _quads_ for pixel shading. Then the process continues on software until it's finally rendered to screen.

Gallium softpipe driver is used for current driver implementation. Modified files from original Mesa sources: sp_setup.c and sp_setup.h. These files are some messed and changes are left mostly uncommented. I should correct this as soon as possible, including separate FPGA specific code in other files. One of the most important organization objectives is to prepare a new Gallium driver for correct merge in a possible Mesa contribution -- if it's important some day, of course.

# Contributing
Help me in development, organizing stuff or even telling me some mistake I did. I frequently do things in a statistic large variance way, so help from others and from time is essential to me :)

Thanks for reading!
