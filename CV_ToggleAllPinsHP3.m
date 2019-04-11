function CV_ToggleAllPinsHP3(app,value)
    colorOn     = [0.49,0.18,0.56];
    colorOff    = [.9, .9, .9];
    if strcmp(value,'On')
        app.P1_3.Text = "ON";
        app.P2_3.Text = "ON";
        app.P3_3.Text = "ON";
        app.P4_3.Text = "ON";
        app.P5_3.Text = "ON";
        app.P6_3.Text = "ON";
        app.P7_3.Text = "ON";
        app.P8_3.Text = "ON";
        app.P1Lamp_3.Color = colorOn;
        app.P2Lamp_3.Color = colorOn;
        app.P3Lamp_3.Color = colorOn;
        app.P4Lamp_3.Color = colorOn;
        app.P5Lamp_3.Color = colorOn;
        app.P6Lamp_3.Color = colorOn;
        app.P7Lamp_3.Color = colorOn;
        app.P8Lamp_3.Color = colorOn;
        
        app.P1_3.Value = 1;
        app.P2_3.Value = 1;
        app.P3_3.Value = 1;
        app.P4_3.Value = 1;
        app.P5_3.Value = 1;
        app.P6_3.Value = 1;
        app.P7_3.Value = 1;
        app.P8_3.Value = 1;
    else
        app.P1_3.Text = "OFF";
        app.P2_3.Text = "OFF";
        app.P3_3.Text = "OFF";
        app.P4_3.Text = "OFF";
        app.P5_3.Text = "OFF";
        app.P6_3.Text = "OFF";
        app.P7_3.Text = "OFF";
        app.P8_3.Text = "OFF";
        app.P1Lamp_3.Color = colorOff;
        app.P2Lamp_3.Color = colorOff;
        app.P3Lamp_3.Color = colorOff;
        app.P4Lamp_3.Color = colorOff;
        app.P5Lamp_3.Color = colorOff;
        app.P6Lamp_3.Color = colorOff;
        app.P7Lamp_3.Color = colorOff;
        app.P8Lamp_3.Color = colorOff;
        
        app.P1_3.Value = 0;
        app.P2_3.Value = 0;
        app.P3_3.Value = 0;
        app.P4_3.Value = 0;
        app.P5_3.Value = 0;
        app.P6_3.Value = 0;
        app.P7_3.Value = 0;
        app.P8_3.Value = 0;
    end
end