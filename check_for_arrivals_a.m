function pkt_num = check_for_arrivals_a(flow, current_time); 
 
global ATIMES_a; 
global NUM_PKTS; 
 
pkt_num = 0; 
 
for j = 1:NUM_PKTS; 
 
 if (ATIMES_a(flow, j) <= current_time) 
 pkt_num = j; 
 
 return; 
 
 end; 
end; 
 