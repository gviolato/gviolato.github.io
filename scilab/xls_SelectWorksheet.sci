function ret = xls_SelectWorksheet(WorksheetName)
    
    ret = %f;
    Worksheet = 0;
    r = %t;
    while r
        Worksheet = Worksheet + 1;
        try
            r = xls_SetWorksheet(Worksheet);
        catch
            r = xls_SetWorksheet(1);
            break;
        end
        name = xls_GetWorksheetName();
        if name==WorksheetName then
            ret = %t;
            break;
        end
    end
    
endfunction
