function conmat = generate_conmat(Nc,Nc_conE,Nc_conI,wmax)
	conmat = zeros(Nc,1);
	rvec = randperm(Nc);
	conmat(rvec(1:Nc_conE)) = wmax*rand(Nc_conE,1);
	conmat(rvec((Nc_conE+1):(Nc_conE+Nc_conI))) = -wmax*rand(Nc_conI,1);
end
