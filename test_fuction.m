function pinStates=test_fuction(app,varargin)

if(nargin==1)
    MD=app.MD;
else
    if(nargin==2)
        MD=varargin{1};
    else
        error('too many arguments');
    end
end

pinStates   = MD(1).PinState;