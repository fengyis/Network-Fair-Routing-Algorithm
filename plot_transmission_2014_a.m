function plot_transmission_2014_a(flow, pkt_num, current_time, tx_time) 
 
 
global BITS_a; 


color_vector = ['r', 'b', 'g', 'c', 'm']; 
 
flow_color = color_vector(flow); 
 
% plot a vertical line to show the bits in Q intially 
 
%j = pkt_num; 
 
x = current_time; 
y = BITS_a(flow,pkt_num); 
 
plot([x, x], [0, y], flow_color, 'LineWidth', 2); 
hold on;
%pause;
% plot a diagonal line to show the bits remaining in Q 
x2 = x + tx_time; 
 
plot([x, x2], [y, 0], flow_color, 'LineWidth', 2); 
 
fprintf('Plotted TX: flow %g, pkt %g\n', flow, pkt_num); 
fprintf('Plotted TX: current_time %g, txtime %g\n', x, tx_time); 
end 
