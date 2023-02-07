function conmat= generate_conmat(Nc)
% half of the population are connected, E+I = 0.5
E = 0.4;
I = 0.1;
wmax = 8;

Nc_conE = round(Nc*E);
Nc_conI = round(Nc*I);

conmat = zeros(Nc,1);
rvec = randperm(Nc);%shuffle the sequence

conmat(rvec(1:Nc_conE)) = wmax*rand(Nc_conE,1);
conmat(rvec((Nc_conE+1):(Nc_conE+Nc_conI))) = -wmax*rand(Nc_conI,1);
end