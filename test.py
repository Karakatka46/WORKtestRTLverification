@cocotb.test();
async def test(dut):
    for _ in range(20):
         exu2ialu_main_op1_i,  exu2ialu_main_op2_i,  exu2ialu_cmd_i = [random.randint(0, 1) for _ in range(3)]
         expected_main_res_o =  exu2ialu_main_op1_i ^  exu2ialu_main_op2_i ^  exu2ialu_cmd_i
         expected_cmp_res_o = ( exu2ialu_main_op1_i &  exu2ialu_main_op2_i) | ( exu2ialu_main_op2_i &  exu2ialu_cmd_i) | ( exu2ialu_main_op1_i &  exu2ialu_cmd_i)
        
         dut.main_op1_i <=  exu2ialu_main_op1_i
         dut.main_op2_i <=  exu2ialu_main_op2_i
         dut.cmd_i <=  exu2ialu_cmd_i
         yield cocotb.trigger()
        
         ialu2exu_main_res_o = dut.exu2ialu_main_res_o.value.integer
         ialu2exu_cmp_res_o = dut.exu2ialu_cmp_res_o.value.integer
        
         if ialu2exu_main_res_o != expected_main_res_o or ialu2exu_cmp_res_o != expected_cmp_res_o:
            raise TestFailure(
                f"Error: A={exu2ialu_main_op1_i}, B={exu2ialu_main_op2_i}, cmd={exu2ialu_cmd_i}, main_res={ialu2exu_main_res_o}, cmp_res={ialu2exu_cmp_res_o} - Expected: main_res={expected_main_res_o}, Cout={expected_cmp_res_o}"
            )

