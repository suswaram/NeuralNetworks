%   Neural network 1-3-1 learning the tangent curve

number = 10; 		% used to get random input values, 10 on the negative side, 10 on the positive side
pi = 3.1;    		% defining value of pi
learning_rate = 0.1;	% learning rate
limit = 0.25;		% limits of the range of inputs, eg. if limit is 0.5 i.e. 1/2, then the range is (-pi/2,pi/2)

%
%	Nomenclature for elements in the neural network:
%	
%_______________________________________________________________________________________________
%	Layer 1			|	Layer 2			| 	Layer 3			|
%_______________________________________________________________________________________________
%				|				|				|
%	bias = bias_input	|	bias = bias_hidden	|	bias = bias_output	|
%				|				|				|
%	input = x_input		|	input = x_hidden	|	input = x_output	|
%				|				|				|
%    for the summation function:|				|				|
%	output = y_first	|	output = y_second	|	output = y_third	|
%				|				|				|
%    for the output of tau function:				|				|
%	output = x_hidden	|	output = x_output	|	output = y_target	|
%				|				|				|
%_______________________________________________________________________________________________

% generating random positive inputs between 0 to 1
x_input = rand(1,number);

% scaling the inputs to the limits
%x_input = x_input * limit *pi;
x_input = x_input * 1.5;

x_0 = [ 0 ];
x_temp = x_input;
x_input = [x_input,x_0];

% generating random negative inputs between 0 to 1


% scaling the inputs to the limits
%x_temp = x_temp * limit * pi * (-1);
x_temp = x_temp * (-1);
% concatenating the two sets of inputs
x_input = [x_input,x_temp];

scale = tan(max(x_input));

%x_input = sort(x_input);

%x_input = [ 0.00123  0.123 0.456 1.123 0.572 0.0812 -0.812 -0.0123 0.0566 0 -1.111 0.233 -0.413 -0.756 1.023 -0.671 0.0412 -0.712 0.1123 0.166 1.01]


required_output = tan(sort(x_input))/scale;
calculated_output = [];


x_hidden = [ 1 1 1 ];
x_output = [ 1 1 1 ];


y_first = [ 1 ];
y_second = [ 1 1 1 ];
y_third = [ 1 ];

w_input = rand(1,1);
w_hidden = rand(1,3);
w_output = rand(1,3);

b_input = rand(1,1);
b_hidden = rand(1,3);
b_output = rand(1,1);

delta_weight_output = [ 1 ];
delta_weight_hidden = [ 1 1 1 ];
delta_weight_input = [ 1 ];

delta_bias_output = [ 1 ];
delta_bias_hidden = [ 1 1 1 ];
delta_bias_input = [ 1 ];


grad_output = [ 1 ];
grad_hidden = [ 1 1 1 ];


function [dy] = sigmoid_derivative(s)
dy = (4 * exp(-2*s)) ./ ((1 + exp(-2*s)) .* (1 + exp(-2*s))); 
end

function [ out ] = sigmoidd( s )
	out = (1 - exp(-2*s)) ./ (1 + exp(-2*s));
end

function [ out ] = forward_hidden( x , w , b )
	j = 1;
	for i = x
		out(j)= w(j)*i + b(j);
%		disp(out(j));
		j= j + 1;

	endfor; 
end

function [ out ] = forward_output( x , w , b )
	x_t = transpose(x);
	out = w*x_t;
	out = out + b;
end

function [ delta_hidden ] = propogate_delta_to_hidden(w_output, delta_output)
	j = 1;	
	for i = w_output
		delta_hidden(j) = i * delta_output;
		j = j+1;
	endfor;
end

function [ delta_input ] = propogate_delta_to_input(w_hidden, delta_hidden)
	w_hidden_t = transpose(w_hidden);
	delta_input = delta_hidden*w_hidden_t;
end




for iter = 1:10000
% Looping through all the input cases
	count = 1;
	ctr = ceil(rand(1,1) * 21); 
	for i = x_input(ctr) 

	x_hidden = [ 1 1 1 ];
	x_output = [ 1 1 1 ];


	y_first = [ 1 ];
	y_second = [ 1 1 1 ];
	y_third = [ 1 ];

	
	
	grad_output = [ 1 ];
	grad_hidden = [ 1 1 1 ];
		
	delta_weight_output = [ 1 1 1];
	delta_weight_hidden = [ 1 1 1 ];
	delta_weight_input = [ 1 ];

	delta_bias_output = [ 1 1 1];
	delta_bias_hidden = [ 1 1 1 ];
	delta_bias_input = [ 1 ];

	%
	% Forward Pass begins:
	%
		%disp(i) 
	% layer 1 
		y_first = i * w_input(1) + b_input(1);     
		out = sigmoidd(y_first);  	
		x_hidden = x_hidden * out;

		y_second = forward_hidden(x_hidden,w_hidden,b_hidden);

	% layer 2
		k = 1;	
		for j = y_second
			x_output(k) = sigmoidd(j);
			k = k + 1;	
		endfor;
	% layer 3
		y_third = forward_output(x_output, w_output, b_output);
		y_target = sigmoidd(y_third);
		%disp(y_target);

	% find actual tan answer
		y_expected = tan(i)/scale;	

	% calculating gradient
		grad_output(1) = (y_expected - y_target) * sigmoid_derivative(y_target);
		
		grad_hidden(1) = (1- x_output(1))*(x_output(1))*grad_output(1)*(w_output(1));
		grad_hidden(2) = (1- x_output(2))*(x_output(2))*grad_output(1)*(w_output(2));
		grad_hidden(3) = (1- x_output(3))*(x_output(3))*grad_output(1)*(w_output(3));
		
		grad_input(1) = (1- x_hidden(1))*(x_hidden(1))*(grad_hidden(1)*(w_hidden(1)) + grad_hidden(2)*(w_hidden(2)) + grad_hidden(3)*(w_hidden(3)));
		

	% calculating delta for weight
		delta_weight_output(1) = learning_rate*grad_output(1)*x_output(1);
		delta_weight_output(2) = learning_rate*grad_output(1)*x_output(2);
		delta_weight_output(3) = learning_rate*grad_output(1)*x_output(3);

		delta_weight_hidden(1) = learning_rate*grad_hidden(1)*x_hidden(1);
		delta_weight_hidden(2) = learning_rate*grad_hidden(2)*x_hidden(2);
		delta_weight_hidden(3) = learning_rate*grad_hidden(3)*x_hidden(3);
		
		delta_weight_input(1) = learning_rate*grad_input(1)*i;

	% calculating delta for bias
		delta_bias_output(1) = learning_rate*grad_output(1);
		for temp = 1:3
			delta_bias_hidden(temp) = learning_rate*grad_hidden(temp);
		endfor;
		delta_bias_input(1) = learning_rate*grad_input(1);

	% updating weights
		for temp = 1:3
			w_output(temp) = w_output(temp) + delta_weight_output(temp);
			w_hidden(temp) = w_hidden(temp) + delta_weight_hidden(temp);
		endfor;		
		w_input(1) = w_input(1) + delta_weight_input(1);

	% updating bias
		b_output(1) = b_output(1) + delta_bias_output(1);
		for temp = 1:3
			b_hidden(temp) = b_hidden(temp) + delta_bias_hidden(temp);
		endfor;		
		b_input(1) = b_input(1) + delta_bias_input(1);
		
		
	
	endfor;

	fprintf("Interation %d: %f %f %f \n",iter,w_input, w_hidden,w_output);
	%key = input('<Press enter to continue, q to quit.>', 's');

	%if (key == 'q' || iter == 100)
	 %  return;
	%end


%	plot(x_input,required_output,x_input,calculated_output);


	

endfor;


% run forward passs again to get values

	count1 =1;
	for i = sort(x_input)
		x_hidden = [ 1 1 1 ];
		x_output = [ 1 1 1 ];


		y_first = [ 1 ];
		y_second = [ 1 1 1 ];
		y_third = [ 1 ];
		% layer 1 
			y_first = i * w_input(1) + b_input(1);     
			out = sigmoidd(y_first);  	
			x_hidden = x_hidden * out;
	
			y_second = forward_hidden(x_hidden,w_hidden,b_hidden);

		% layer 2
			k = 1;	
			for j = y_second
				x_output(k) = sigmoidd(j);
				k = k + 1;	
			endfor;
		% layer 3
			y_third = forward_output(x_output, w_output, b_output);
			y_target = sigmoidd(y_third);
			%disp(y_target);
		
			calculated_output(count1) = y_target;
			count1 = count1 +1;
	endfor;

		plot_x = sort(x_input);
		plot_y1 = calculated_output;
		plot_y2 = required_output;
		plot(plot_x,plot_y1,plot_x,plot_y2/scale);	








