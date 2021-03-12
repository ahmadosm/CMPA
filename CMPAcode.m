%%  
%AO 101070948
Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3; 
Gp = 0.1; 

%%
%part 1
Voltage = linspace(-1.95,0.7,200);
I_current = (Is*(exp(1.2*Voltage/0.025)-1)) + (Gp*Voltage) - (Ib*(exp(-1.2*(Voltage+Vb)/0.025)-1));
r = (1.2-0.8).*rand(size(I_current)) + 0.8;
I_20 = r.*I_current;
figure('name','Part1')
subplot(2,1,1)
plot(Voltage,I_current,Voltage,I_20)
subplot(2,1,2)
semilogy(Voltage,abs(I_current),Voltage,abs(I_20))

%%
%part 2
p_4 = polyfit(Voltage,I_current,4);
p_8 = polyfit(Voltage,I_current,8);
pv_4 = polyval(p_4,Voltage);
pv_8 = polyval(p_8,Voltage);
p_420 = polyfit(Voltage,I_20,4);
p_820 = polyfit(Voltage,I_20,8);
pv_420 = polyval(p_420,Voltage);
pv_820 = polyval(p_820,Voltage);
figure('name','Part2')
subplot(2,2,1)
plot(Voltage,I_current,'r',Voltage,pv4,'b')
title('no noise p4, AO-101070948')
subplot(2,2,2)
plot(Voltage,I_current,'r',Voltage,pv_8,'b')
title('no noise p8, AO-101070948')
subplot(2,2,3)
semilogy(Voltage,abs(I_current),'r',Voltage,abs(pv_420),'b')
title('noise p4, AO-101070948')
subplot(2,2,4)
semilogy(Voltage,abs(I_current),'r',Voltage,abs(pv_820),'b')
title('noise p8, AO-101070948')
%%
%part 3
fo_1 = fittype('A*(exp(1.2*x/0.025)-1) + (0.1*x) - (C*(exp(-1.2*(x+1.3)/0.025)-1))');
ff_1 = fit(Voltage',I_current',fo_1);
If_1 = ff_1(Voltage);
fo_2 = fittype('A*(exp(1.2*x/0.025)-1) + (B*x) - (C*(exp(-1.2*(x+1.3)/0.025)-1))');
ff_2 = fit(Voltage',I_current',fo_2);
If_2 = ff_2(Voltage);
fo_3 = fittype('A*(exp(1.2*x/0.025)-1) + (B*x) - (C*(exp(-1.2*(x+D)/0.025)-1))');
ff_3 = fit(Voltage',I_current',fo_3);
If_3 = ff_3(Voltage);
figure('name','Part3')
subplot(3,1,1)
semilogy(Voltage,abs(If_1'),'b',Voltage,abs(I_20),'r')
title('2 fitted, AO-101070948')
subplot(3,1,2)
semilogy(Voltage,abs(If_2'),'b',Voltage,abs(I_20),'r')
title('3 fitted, AO-101070948')
subplot(3,1,3)
semilogy(Voltage,abs(If_3'),'b',Voltage,abs(I_20),'r')
title('4 fitted, AO-101070948')

%part 4
input = Voltage.';
target = I_current.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize); 
net.divideParam.trainRatio = 70/100; 
net.divideParam.valRatio = 15/100; net.divideParam.testRatio = 15/100; 
[net,tr] = train(net,input,target);
output = net(input);
errors = gsubtract(output,target); performance = perform(net,target,output); view(net)
Inn = output;
figure('AO-101070948','part4')
subplot(2,1,1)
plot(input,Inn,'b',input,I_20,'r')
subplot(2,1,2)
semilogy(input,abs(Inn),'b',input,abs(I_20),'r')