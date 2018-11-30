

# Course tutor

  * CHERIF Bilel
  * email : bcherif@laas.fr

# Documentation

  * [[http://www.zynqbook.com|The Zynq Book]] : un livre sur le SOC Zynq de renommée internationale
  * {{:hard:5siec_zynq:using_gic.pdf|}} Altera (le concurrent de ZYNQ, utilise le même contrôleur d'interruption que ZYNQ puisqu'il est fabriqué par ARM) propose une documentation plus digeste que celle de ARM ou Xilinx. {{:hard:5siec_zynq:using_gic.pdf|}}
  * {{:hard:5siec_zynq:arm_a9_intro_alt.pdf|Intro ARM9 faite par Altera}}
  * Zynq TRM [[https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf | here]]
  * Vivado HLS user manual [[https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_1/ug902-vivado-high-level-synthesis.pdf | here]]

## Course files
{{:hard:5siec_zynq:cours_01.pdf|}}

{{:hard:5siec_zynq:cours_2.pdf|}}

# TP Files

## TP 01 doccuments

  * {{:hard:5siec_zynq:tp01.pdf|}}
  * {{:hard:5siec_zynq:tp01_guide.pdf|}}
  * Trying to explain IRQ handling mechanism in one page here {{:hard:5siec_zynq:irq_handling.pdf|}}
  * Bare metal drivers doccumentation [[http://www.wiki.xilinx.com/Baremetal+Drivers+and+Libraries | here]]
  * Cortex A9 Processor Exception Handling (ckeck this link for a better understanding of the xilinix supplied exception handler page 23) [[https://www.xilinx.com/support/documentation/sw_manuals/xilinx2015_1/oslib_rm.pdf | here]]
  * Zybo referance manual [[https://www.xilinx.com/support/documentation/university/XUP%20Boards/XUPZYBO/documentation/ZYBO_RM_B_V6.pdf | here]]

## TP 02 doccuments

  * {{:hard:5siec_zynq:tp02.pdf|}} (a report should be sent to my email by the end of the TP)(this is a two sessions TP)
          * the report should contain the simulation waveform, the response to questions, the hdl codes, and the c code
  * Constraints file {{:hard:5siec_zynq:zybo_master.doc|}}
  * Video tutorials
         * Adding constraints file [[https://www.youtube.com/watch?v=baFEqLVBG1E | youtube]]
         * IP creator [[https://www.youtube.com/watch?v=gnbRVULOWoU | youtube]]
         * IP packaging [[https://www.youtube.com/watch?v=Xzvocc-HCl0&feature=youtu.be | youtube]]
         * Writing to memory addresses [[https://www.youtube.com/watch?v=pGkhvc36sgU | youtube]]

# TD

## Double handshake protocol TD1

  * {{:hard:5siec_zynq:td01.pdf|}}
  * Testbench example {{:hard:5siec_zynq:testbench.vhd|}}
  * Exo1 source codes :
         * CODE {{:hard:5siec_zynq:td_ex01.vhd|}}
         * TB {{:hard:5siec_zynq:tb_td_ex01.vhd|}}
## Hardware debug TD2

  * {{:hard:5siec_zynq:td02.pdf|}}
  * ILA documentation [[https://www.xilinx.com/support/documentation/ip_documentation/ila/v6_1/pg172-ila.pdf | here]]
  * JTAG to AXI Master documentation [[https://www.xilinx.com/support/documentation/ip_documentation/jtag_axi/v1_2/pg174-jtag-axi.pdf | here]]
  * ILA video Tutorial [[https://www.youtube.com/watch?v=SllATwKoBmA&feature=youtu.be | youtube]]


# Final project

In this project we will develop a prototype pf a guitar multi-effects pedal (we will use just two effects to demonstrate the feasibility of the Project).

  * Project doccument {{:hard:5siec_zynq:project.pdf|}}
  * Constraints file {{:hard:5siec_zynq:project_constraints.doc|}}
  * Zybo audio control IP {{:hard:5siec_zynq:xilinx_com_zybo_audio_ctrl_1.0.zip|}}
  * audio driver source code {{:hard:5siec_zynq:src.rar|}}
  * SSM2603 datasheet [[http://www.analog.com/media/en/technical-documentation/data-sheets/SSM2603.pdf | here]]
  * VHDL Testbench generation tool [[http://vhdl.lapinoo.net/testbench/ | here]]
