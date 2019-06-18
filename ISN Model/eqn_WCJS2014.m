% The WC differential equations used in Jadi and Sejnowski, 2014

function dy = eqn_WCJS2014(~,y,wcParams,stimParams,outParam)

if ~exist('outParam','var');              outParam=0;                   end

dy = zeros(2,1);
dy(1) = (-y(1) + Gx(wcParams.Wee*y(1) - wcParams.Wei*y(2) + stimParams.e,wcParams.thetaE,wcParams.m,wcParams.modelParam))./wcParams.taue;
dy(2) = (-y(2) + Gx(wcParams.Wie*y(1) - wcParams.Wii*y(2) + stimParams.i,wcParams.thetaI,wcParams.m,wcParams.modelParam))./wcParams.taui;

if outParam==1
    dy=dy(1);
elseif outParam==2
    dy=dy(2);
end
end
function g = Gx(x,theta,m,modelParam)

if strcmp(modelParam,'sig')
    g = 1/(1+exp(-m*(x-theta)))- 1/(1+exp(m*theta));
%     g = 1/(1+exp(-m*(x-theta))) - 1/(1+exp(m*(x-theta)));

elseif strcmp(modelParam,'pp')
    if x<theta
        g=0;
    else
        g=min(1,m*(x-theta).^3);
    end
elseif strcmp(modelParam,'pl')
    if x<theta
        g=0;
    elseif x<theta+1/m
        g=m*(x-theta);
    else
        g=1;
    end
end
end