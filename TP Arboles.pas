program TP;
        type
        lista_ventas = ^nodo_ventas;
        info = record
             codProd: integer;
             cantVend: integer;
             numCli: integer;
        end;
        nodo_ventas = record
                    datos: info;
                    sig: lista_ventas;
                end;
        arbol_stock = ^nodo_stock;
        infoStock = record
                  codProd: integer;
                  stockActual: integer;
                  stockMinimo: integer;
              end;
        nodo_stock = record
                   datos: infoStock;
                   hIzq: arbol_stock;
                   hDer: arbol_stock;
               end;
        lista_codigos = ^nodo_codigos;
        nodo_codigos = record
                     codProd: integer;
                     sig: lista_codigos;
                 end;




 function buscar (A_stock: arbol_stock; elem: integer): arbol_stock;
 begin
  if (A_stock = nil) then Buscar:= nil
    else
      if (elem = A_stock^.datos.codProd) then Buscar:= A_stock
      else
        if (elem < A_stock^.datos.codProd) then
          Buscar:=Buscar(A_stock^.hIzq ,elem)
        else
          Buscar:=Buscar(A_stock^.hDer ,elem)
 end;


    procedure actualizacion_stock(L_ventas:lista_ventas; A_stock: arbol_stock);
      begin
      while (L_ventas <> nil) do begin
         A_stock:=buscar(A_stock, L_ventas^.datos.codProd);
         A_stock^.datos.stockActual:= A_stock^.datos.stockActual - L_ventas^.datos.cantVend;
         L_ventas:= L_ventas^.sig;
      end;
    end;


    procedure agregarNodo(var lisCod: lista_codigos; A_stock: arbol_stock; var ult: lista_codigos);
      var nue: lista_codigos;
      begin
      new(nue);
      nue^.sig:= nil;
      nue^.codProd:= A_stock^.datos.codProd;
      if (lisCod = nil) then
        lisCod:= nue
      else
        ult^.sig:= nue;
      ult:= nue;
    end;



    procedure crearNuevaEst(A_stock: arbol_stock; var lisCod: lista_codigos);
      var ult: lista_codigos;
      begin
      lisCod:= nil;
      if (A_stock = nil) then begin
        if(A_stock^.datos.stockActual < A_stock^.datos.stockMinimo) then
           agregarNodo(lisCod, A_stock, ult);
        crearNuevaEst(A_stock^.hIzq, lisCod);
        crearNuevaEst(A_stock^.hDer, lisCod);
      end;
    end;


    procedure buscarMin(var codMin: integer; A_stock: arbol_stock; actMin: integer);
      begin
      if (A_stock^.datos.stockActual < actMin) then begin
        actMin:= A_stock^.datos.stockActual;
        codMin:= A_stock^.datos.codProd;
      end;
    end;




    procedure Cod_prod_min_stock(A_stock: arbol_stock);
    var codMin: integer; actMin: integer;
    begin
    actMin:= 9999;
    if (A_stock <> nil) then begin
      if (A_stock^.datos.codProd >= 10) then
         if(A_stock^.datos.codProd <= 50) then begin
            buscarMin(codMin, A_stock, actMin);
            Cod_prod_min_stock(A_stock^.hizq);
            Cod_prod_min_stock(A_stock^.hder);
         end
         else
             Cod_prod_min_stock(A_stock^.hizq)
       else
            Cod_prod_min_stock(A_stock^.hder);
    end;
    writeln(codMin);
    end;


    procedure buscarMax(var codMax: integer; A_stock: arbol_stock; actMax: integer);
      begin
      if(A_stock^.datos.stockActual > actMax) then begin
        actMax:= A_stock^.datos.stockActual;
        codMax:= A_stock^.datos.codProd;
      end;
    end;


    procedure Cod_prod_max_stock(A_stock: arbol_stock; var Max: integer;var codMax: integer);
      begin

      if(A_stock <> nil) then begin
        if(A_stock^.datos.stockMinimo >=100) and (A_stock^.datos.stockMinimo <=500) then
          buscarMax(codMax, A_stock, Max);
          Cod_prod_max_stock(A_stock^.hizq,max,codmax);
          Cod_prod_max_stock(A_stock^.hder,max,codmax);
      end;
      writeln(codMax);
    end;


    var
    L_ventas: lista_ventas; A_stock: arbol_stock;
    lisCod: lista_codigos;
    max,codmax:integer;
    begin
    max:=-1;
    crearListaSup(L_ventas); {se dispone}
    crearArbol(A_stock);     {se dispone}
    actualizacion_stock(L_ventas,A_stock);
    crearNuevaEst(A_stock, lisCod);
    Cod_prod_min_stock(A_stock);
    Cod_prod_max_stock(A_stock,max,codmax);
    readln;
end.
