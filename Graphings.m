% 1500 is 0 and 1800 is 27
% ratio= 300/27;
% (1800-1500)/11.1111;
% figure;plot(simout);hold on;plot(simout1);
% figure;plot(ch_yaw);hold on;plot(yaw);

%%
% load('WorkspaceWithRvaryingRolls3.mat');

figure;plot(Ris1ch,'r--');
hold on;plot(Ris1_,'k','Linewidth',1); 
hold on;plot(Ris2_,'b','Linewidth',1); 
hold on;plot(Ris3_,'g','Linewidth',1);
xlabel('time (sec)');ylabel('roll (deg)');
legend('Desired angle','R = 1','R = 2','R = 3');
hold on; set(gca,'fontsize',16); hold off;

figure;plot(Ris1ch,'r--');
hold on;plot(Ris01_,'k','Linewidth',1); 
hold on;plot(Ris1_,'b','Linewidth',1); 
hold on;plot(Ris3_,'g','Linewidth',1); 
hold on;plot(Ris10_,'y','Linewidth',1); 
xlabel('time (sec)');ylabel('roll (deg)');
legend('Desired angle','R = 0.1','R = 1','R = 3','R = 10');
hold on; set(gca,'fontsize',16); hold off;
%%
% load('VaryingRforYAW2.mat');
figure;plot(ch_yaw_Ris1, 'r--');
hold on;plot(yawRis1,'k','Linewidth',1); 
hold on; plot(yawRis2,'b','Linewidth',1); 
hold on; plot(yawRis3,'g','Linewidth',1); 
xlabel('time (sec)');ylabel('yaw (deg)');
legend('Desired angle','R = 1','R = 2','R = 3');
hold on; set(gca,'fontsize',16); hold off;


figure;plot(ch_yaw_Ris1,'r--');
hold on;plot(yawRis0001,'k','Linewidth',1); 
hold on;plot(yawRis0005,'b','Linewidth',1); 
hold on;plot(yawRis001,'g','Linewidth',1); 
xlabel('time (sec)');ylabel('yaw (deg)');
legend('Desired angle','R = 0.001','R = 0.005','R = 0.01');
hold on; set(gca,'fontsize',16); hold off;

figure;plot(ch_yaw_Ris1,'r--');
hold on;plot(yawRis01,'k','Linewidth',1); 
hold on;plot(yawRis1,'b','Linewidth',1); 
xlabel('time (sec)');ylabel('yaw (deg)');
legend('Desired angle','R = 0.1','R = 1');
hold on; set(gca,'fontsize',16); hold off;
%% 
% subplot(3,1,1);plot(roll);hold on; plot(ch_roll)
% subplot(3,1,2);plot(pitch);hold on; plot(ch_pitch)
% subplot(3,1,3);plot(yaw);hold on; plot(ch_yaw)

figure; subplot(2,1,1); 
plot(Ris1ch,'r--');
hold on;plot(Ris1_,'k','Linewidth',1); 
hold on;plot(Ris2_,'b','Linewidth',1); 
hold on;plot(Ris3_,'g','Linewidth',1); grid on;
% xlabel('time (sec)');
ylabel('roll (deg)'); xlim([0 1.2]);
legend('Desired angle','R = 1','R = 2','R = 3');
hold on; set(gca,'fontsize',16); hold off;

subplot(2,1,2);plot(Ris1ch,'r--');
hold on;plot(Ris01_,'k','Linewidth',1); 
hold on;plot(Ris1_,'b','Linewidth',1); 
hold on;plot(Ris3_,'g','Linewidth',1); 
hold on;plot(Ris10_,'y','Linewidth',1); grid on;
xlabel('time (sec)');ylabel('roll (deg)'); grid on;
xlim([0 1.2]);
legend('Desired angle','R = 0.1','R = 1','R = 3','R = 10');
hold on; set(gca,'fontsize',16); hold off;


figure;subplot(3,1,1);
plot(ch_yaw_Ris1, 'r--');
hold on;plot(yawRis1,'k','Linewidth',1); 
hold on; plot(yawRis2,'b','Linewidth',1); 
hold on; plot(yawRis3,'g','Linewidth',1); grid on;
% xlabel('time (sec)');
ylabel('yaw (deg)'); xlim([0 12.5]); ylim([0 16]);
legend('Desired angle','R = 1','R = 2','R = 3');
hold on; set(gca,'fontsize',16); hold off;

subplot (3,1,2);
hold on;plot(ch_yaw_Ris1,'r--');
hold on;plot(yawRis01,'k','Linewidth',1); 
hold on;plot(yawRis1,'b','Linewidth',1); 
ylabel('yaw (deg)');
xlim([0 8]); ylim([0 15]);
legend('Desired angle','R = 0.1','R = 1'); grid on;
hold on; set(gca,'fontsize',16); hold off;

subplot (3,1,3); plot(ch_yaw_Ris1,'r--');
hold on;plot(yawRis0001,'k','Linewidth',1); 
hold on;plot(yawRis0005,'b','Linewidth',1); 
hold on;plot(yawRis001,'g','Linewidth',1); grid on;
% xlabel('time (sec)');
xlabel('time (sec)');ylabel('yaw (deg)'); 
xlim([0 0.8]); ylim([0 10.5]);
legend('Desired angle','R = 0.001','R = 0.005','R = 0.01');
hold on; set(gca,'fontsize',16); hold off;

