# Função para verificar se um número é primo
def eh_primo(n):
    if n < 2:
        return False
    for i in range(2, n):
        if n % i == 0:
            return False
    return True

# Exibindo números primos até 20
for num in range(1, 21):
    if eh_primo(num):
        print(num)
