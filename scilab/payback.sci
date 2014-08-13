function n = payback(FC)
// Função para o cálculo de payback
//
// Parâmetro de entrada: FC - Fluxo de Caixa
// Parâmetro de saída:   n - Número de períodos
//
// Autor: Júlio Xavier Vianna Neto

n = 1;
while sum(FC(1:n+1)) < 0
    n = n + 1;
    if n + 1 > length(FC) then
        n = %nan;
        return;
    end
end

endfunction
