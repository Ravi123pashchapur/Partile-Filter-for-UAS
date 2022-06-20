%% Author : Ravi Ashok Pashchapur
%% Date: 08 /07 / 2019
%% license: MIT

function [x_state,P_cov,K_EKF_gain,diff,Z_hat]=PF_form(xy1,xy2,h_0,alpha,x_state_ini,P_cov_ini,F,G,Q,R)

    
    persistent Part X_s P_s init
    
 %% Initilization of estimate and error covarience.
    
    N_particle = 1000;                                                        % Number of Particles
    
    if isempty(init)
        init = 1;
        
        for i = 1 : N_particle                                               % Initialization of particle to both variances
            
            P_init(1,:)=4000*rand(1,N_particle) + 4000;                     
            P_init(2,:)=4000*rand(1,N_particle) + 4000;            
        end
        
        
        Part = P_init;                                                         % Initial Particle covariance
        
    end
    
    
 %% Convolution of Particle Filter 
    
    Z_p = alpha;                                                             % Jammer Measurment
    
    for i = 1 : N_particle
        P_o(:, i) = Part(:, i) + G*sqrt(Q) * [randn; randn];
        Z_hat = measure(xy1,xy2,P_o(:, i),h_0)+ sqrt(R) * randn;             % Measurment of Particle
        diff =  Z_p - Z_hat;                                                 % Difference between Jammer mesurement and estimated measurement
        W(i) = (1 / sqrt(R) / sqrt(2 * pi)) * exp(-(diff)^2 / 2 / R);        % Weights of the Particle
    end

 % Measurement Update
    W_sum = sum(W);                                                          % Summation of Weights
    
    for i = 1 : N_particle
        W(i) = W(i) / W_sum;                                                 % Normalization of individual weights
    end
    
 %% Resampling step
    
    constant_1 = length(W);
    i =1;
    constant_2 = rand/N_particle;
    j = 0;
    while j < constant_1
        j = j + 1;
        Ns = floor(N_particle*(W(j)-constant_2))+1;
          constant_3 = 1;
          while constant_3 <= Ns
            Part(:,i)=P_o(:,j); 
            i = i + 1; 
            constant_3 = constant_3 + 1;
          end
        constant_2 = constant_2 + Ns/N_particle-W(j);
    end 
    
    
 %% Plotting of particles in figure
    
 hold on
 particles = plot(Part(1,:)/10^3,Part(2,:)/10^3,'b*');
 pause(0.01)
 delete(particles)
 
 % Mean of the particle
 X_s = mean(Part');


 %% Update Step for State Estimate and Error Covarience.
 
 x_state = X_s;                                                             % Updated State Estimate
 
 P_s = eye(2);
 
 K_EKF_gain = [0; 0];
 
 P_cov=P_s;                                                                 % Updated Error Covarience

end 




