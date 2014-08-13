function t = tir(FC)
// Função para o cálculo da Taxa Interna de Retorno (TIR)
//
// Parâmetro de entrada:    FC - Fluxo de Caixa
// Parâmetro de saída:      t - Taxa Interna de Retorno
//
// Autor: Júlio Xavier Vianna Neto

raizes = roots(FC($:-1:1,1)');   // Encontra as raízes do polinômio
taxas = ((1)./raizes) - 1;          // Calcula as taxas correspondentes

ind = find(real(taxas) > 0 & abs(imag(taxas)) < 1e-6);  // Taxas reais e positivas
if ~isempty(ind) then
    t = min(real(taxas(ind)));
else
    ind = find(abs(imag(taxas)) < 1e-6);    // Taxas reais, mesmo que negativas
    if ~isempty(ind) then
        t = max(real(taxas(ind)));
    else
        t = %nan;
    end
end

endfunction
