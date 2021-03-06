function CV_ToggleAllPinsHP1(app,value)
    colorOn     = [0.49,0.18,0.56];
    colorOff    = [.9, .9, .9];
    if strcmp(value,'On')
        app.P1_1.Text = "ON";
        app.P2_1.Text = "ON";
        app.P3_1.Text = "ON";
        app.P4_1.Text = "ON";
        app.P5_1.Text = "ON";
        app.P6_1.Text = "ON";
        app.P7_1.Text = "ON";
        app.P8_1.Text = "ON";
        app.P1Lamp_1.Color = colorOn;
        app.P2Lamp_1.Color = colorOn;
        app.P3Lamp_1.Color = colorOn;
        app.P4Lamp_1.Color = colorOn;
        app.P5Lamp_1.Color = colorOn;
        app.P6Lamp_1.Color = colorOn;
        app.P7Lamp_1.Color = colorOn;
        app.P8Lamp_1.Color = colorOn;
        
        app.P1_1.Value = 1;
        app.P2_1.Value = 1;
        app.P3_1.Value = 1;
        app.P4_1.Value = 1;
        app.P5_1.Value = 1;
        app.P6_1.Value = 1;
        app.P7_1.Value = 1;
        app.P8_1.Value = 1;
    else
        app.P1_1.Text = "OFF";
        app.P2_1.Text = "OFF";
        app.P3_1.Text = "OFF";
        app.P4_1.Text = "OFF";
        app.P5_1.Text = "OFF";
        app.P6_1.Text = "OFF";
        app.P7_1.Text = "OFF";
        app.P8_1.Text = "OFF";
        app.P1Lamp_1.Color = colorOff;
        app.P2Lamp_1.Color = colorOff;
        app.P3Lamp_1.Color = colorOff;
        app.P4Lamp_1.Color = colorOff;
        app.P5Lamp_1.Color = colorOff;
        app.P6Lamp_1.Color = colorOff;
        app.P7Lamp_1.Color = colorOff;
        app.P8Lamp_1.Color = colorOff;
        
        app.P1_1.Value = 0;
        app.P2_1.Value = 0;
        app.P3_1.Value = 0;
        app.P4_1.Value = 0;
        app.P5_1.Value = 0;
        app.P6_1.Value = 0;
        app.P7_1.Value = 0;
        app.P8_1.Value = 0;
    end
end