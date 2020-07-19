%DOP simulation
% We plot lines of equal DOP
% We omit the dependence on f_s and c
% We plot lines of equal radial velocity component
% The absolute of constant is smaller
% than abs(v_1-v_t)=1

% The sensor is located at [1,0]
r_1=[1;0];
% The sensor's velocity is [1,0]
v_1=[1;0];
% The emitter is located at [0,0]
r_t=[0;0];
% The emitter's velocity is [0,0]
v_t=[0;0];
c_values=linspace(0,0.99,100);
sqrt_c=c_values./sqrt(1-c_values.^2);

%% DOP>0

figure
hold all
arrayfun(@(c) fplot(@(x)1-c*x,[0,100]),sqrt_c)
grid on
arrayfun(@(c) fplot(@(x)1+c*x,[-100,0]),sqrt_c)
title('lines of equal DOP, DOP>0')
xlabel('x')
ylabel('y')

%% DOP<0
figure
hold all
arrayfun(@(c) fplot(@(x)1+c*x,[0,100]),sqrt_c)
grid on
arrayfun(@(c) fplot(@(x)1-c*x,[-100,0]),sqrt_c)
title('lines of equal DOP, DOP<0')
xlabel('x')
ylabel('y')
