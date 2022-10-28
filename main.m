clear all;clc;close all
tic
mes     = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
ylabels = {'0','1 Ctm','2 Ctm','5 Ctm','10 Ctm','20 Ctm','50 Ctm','1 €','2 €','5 €','10 €','20 €','50 €','100 €','200 €','500 €'};

dias            = 30;
numero_personas = 5;

video           = VideoWriter('loteriaFinal','MPEG-4'); 
video.Quality   = 100;
video.FrameRate = 1;
open(video);
euros_meses     = zeros(numero_personas,12);
x               = 1:dias;

xlabels = {};
for i=1:30
    if mod(i,2)==0
        xlabels{i}=num2str(i);
    else
        xlabels{i}='';
    end
end

for k=1:numero_personas

    f2 = figure;
    set(f2,  'Visible','off');
    set(gcf,'Position',[0 0 1920 1080])
    set(gcf,'color','w');
    sgtitle(['PERSONA : ',num2str(k)])
    set(f2,'defaultAxesColorOrder',[[0 0 0];[0 0 0]]);
    for i=1:12
    
      [euros,eurosA,indx,multi] = indice2euros(dias);
      euros_meses(k,i)          = eurosA(end);
      y1                        = indx ;
      y2                        = multi ;
 
      subplot(4,3,i)
        hold on;box on; grid on
        title([mes{i},': ',num2str(eurosA(end)),' €'])

        yyaxis left
            ylabel('Dado 1',Color='b',FontWeight='bold')
            plot(x,y1,'b-');
            plot(x,y1,'ko',MarkerFaceColor='g',MarkerSize=5)
            yticks(0:16)
            xticks(1:30);
            xticklabels(xlabels)
            xlabel('Dias')
            yticklabels(ylabels)
            axis([1 dias 0 15])
            pbaspect([2 1 1])

        yyaxis right
            ylabel('Dado 2',Color='r',FontWeight='bold')
            plot(x,y2,'ko',MarkerFaceColor='r',MarkerSize=4)
            yticks(0:16)
    end

    if i==1
        writeVideo(video,frame)
    end

    frame = getframe(gcf);drawnow
    writeVideo(video,frame)

end

f3 = figure;
hold on;box on;grid on
set(f3,  'Visible','off');
set(gcf,'Position',[0 0 1920 1080])
set(gcf,'color','w');
xticks(1:12)
xticklabels(mes)
ylabel('€ acumulado')

euros_meses     = cumsum(euros_meses,2);
max_euros_meses = round(max(euros_meses(:))+1e4,-4);

yticks(0:10000:max_euros_meses)
yticklabels(0:10000:max_euros_meses )
colors(1,:) = [0 0.4470 0.7410];
colors(2,:) = [0.8500 0.3250 0.0980];
colors(3,:) = [0.9290 0.6940 0.1250];
colors(4,:) = [0.4940 0.1840 0.5560];
colors(5,:) = [0.4660 0.6740 0.1880];
colors(6,:) = [0.3010 0.7450 0.9330];
colors(7,:) = [0.6350 0.0780 0.1840];
colors(8,:) = [1 0 0];
colors(9,:) = [0 1 0];
colors(10,:) = [1 0 1];

for k=1:numero_personas

    txt_legend = ['Persona ',num2str(k),':  ',num2str(euros_meses(k,end)),' €'];
    p = plot(1:12,euros_meses(k,:),'DisplayName',txt_legend,LineWidth=2);
    p.Color = colors(k,:);
    axis([1 12 0 max_euros_meses ])
    pbaspect([1 1.25 1])

end

l = legend;
l.Location   = 'northwest';
l.FontSize   = 14;
l.FontWeight = 'bold';
title(l,'Total Anual')

frame = getframe(gcf);drawnow
writeVideo(video,frame)
writeVideo(video,frame)

close(video)
toc

function [euros,eurosA,indx,multi] = indice2euros(dias)

         monedas  = [1 2  5  10 20  50  100 200]*0.01;
         billetes = [5 10 20 50 100 200 500 0];
         dinero   = [monedas billetes];
         n        = length(dinero);
         while true
    
                 indx     = randi([1,n],dias,1);
                 multi    = randi([0,n-1],dias,1);
                 euros    = dinero(indx);
                 euros    = euros.*multi';
                 eurosA   = cumsum(euros);
                 indx0    = find(indx==16);
                 indx(indx0) =0;
                 diferencia  =  indx - multi;
                 diferencia0 = find(diferencia == 0);
           
                 if length(diferencia0)==0
                    break
                 end
         end
end





    
    
