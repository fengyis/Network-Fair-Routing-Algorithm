function pkt_num = check_for_arrivals(flow, current_time); 
 
global ATIMES; 
global NUM_PKTS; 
 
pkt_num = 0; 
 
for j = 1:NUM_PKTS; 
 
 if (ATIMES(flow, j) <= current_time) 
 pkt_num = j; 
 
 return; 
 
 end; 
end; 
 