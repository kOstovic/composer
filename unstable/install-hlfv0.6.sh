(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� M�,Y �]o�0���ᦐ� �21�BJ�AI`�U<�%�eS���ABºJզI~	9�s|αq{q��0�`k繵w�'�zz��|�NE��	�@>�+Q��x�#����?�2I[�Z��E�u���SR�#�����)�a$] �AoE|8�� ȳ�P�]��5�܃���n�O�=��i�^Kh��>f�� ���D 4A��v$zid6����(���Yӵ����ʳ��"��1N`&#m�Y�#�%�4�_�9��)Z�F�7
6�ڄ��Mm��M�6�7+��l�eY3��&��`a�#ِ��q��rJ1�����O|�$q�Z�É�9�vnE�V����d66y)+��|�W�~2��U8�'�L*0��s�5<�7ުW�?��Å61���P%�TE!�a��ŝ�ȣ&���}��ڷ$\��E�6��n�ua�M4"�t?�e��!�t@��s�UO:S��9����/A3t����T��5�K�ҨZ`>O'��h�:��:��P��N���w ������>�cr��q��\ե��h6��-y�Ϸ<H�G����QH_A�w�Ā�lH�n/���p?sٹ�����q�3�	<x�3�:d���!YA��'�gq�B}�.4�N�ơMv�I×'��TB�9z ��0%q�%�J�X���v_,(K���%��`���9��|Y�{.1o*��x(+��?��Ň�ޭ����׿�_e0��`0��`0��`0�o���� (  