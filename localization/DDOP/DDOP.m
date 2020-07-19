%Asuming MKS units
% We assume the transmitter is stationary in the (x,y) plane
v_1_factor=200;
v_2_factor=100;

v_1=v_1_factor*[1;0;0];
v_2=v_2_factor*[1;1;0];

ratio=v_1_factor/v_2_factor;
height=0;
x_1=[0,0,height];
x_2=[0,10^4,height];
f_0=10^8; % MHz
c=3*10^8; % speed of light
n=1000;
x=linspace(-10^4,2*10^4,n).';
f_0c=f_0/c;
xy_data=[kron(x,ones(n,1)),kron(ones(n,1),x),zeros(n^2,1)];

DDOP_values=2*f_0c*((x_1-xy_data)*v_1./vecnorm(x_1-xy_data,2,2)...
    -(x_2-xy_data)*v_2./vecnorm(x_2-xy_data,2,2));

imagesc(x,x,reshape(DDOP_values,n,n))
grid on
colormap('jet');
colorbar()
title(['DDOP: $\frac{v1}{v2}$=',...
    num2str(ratio),', v1:x v2:diagonal, Height: ',num2str(height)]...
    ,'Interpreter','latex')
xlabel('x')
ylabel('y')
axis xy

% one can add arrows
