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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� N�,Y �]is�J�>��+�������o�J�m @	!�n���			��_��%^pl����$��az���IO��d_��2���__� M��+J�����Bq��K�8^�Cq����_ӝ��dk;���Z��v�����)�G�O|?�������4^f�2#.�?E�x%�2��oK�_��C���_�-�����叒$Yɿ\(��_{�{�l�\�Z��r�K���l���r�SBT�/��5���xv���=�(`� ����Z�{��\@P����j�/��#��?���k�ު���s�?��.��.�y��S6�6J�4JS�C6�,BQ>B:>���`��x�(��M�Us���(C���O/��D��x/�W)c �p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��:+��K������m/�.]?]��~����j��|���*���^'~��o�������@+�_
�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��A �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!e�^=ܗ� v0?�`����С�C�����������N�����5���r7�6�8Xs�+���n�b.�q�|������[K���
�4���6A(�(:�RP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���{B.rp��G�'3�;�A�_�� \�_�[ix⹱� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy`2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l���+����Ϧ�;��#�����O����6����>�%�����[�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�3F��P��1��	���#;� � WS�.�
�{e�ޗ)����u~�e��i(��C�ل��<��.G�މE�r	��b�֐�ek�Dj�b���:w��-��uy�H�\̭���.�� 
@s�e�Rw���=s�mu�4@.�'���	s�0��ax�@����4���Y�@��
�9�W ����&3��r9!��Y��g���n���P��{��oi&�MI!%i㧓F�s��@[�!jCꃙm3�i|����$�E�|����Ś����`�~�n3�'0 ������\ג�p5E�̪9�8L�!����S���w�w��G��$�*��|��_s�������Y���������?���������@q���2�K�������+U�O�����):�I#������8E��?�!h��Ew�e
���E� �h��H�����P�����~�C�D������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*��������?T�_
>K����V��T���_��W��}H�a�Ou��|���J�O�������L���7s(<:��P�қ�]���o�������:vK��������`p�{;h2�c ��U�>2�2<�$�zo*ͭ��3A>���w���]����t�x�͆�f2o�z�D���D!P����]�p�r'�v�ó@�D�s�m�ȸ��IG�^p ?G��qڠy����8�9@z��%�i�V��ڹN�M�}��6Y��.,����μ����´gO&M��@�$0A����^��Y��h1	�x�� ��i��=SZ������SMG��v"FR>�9K����Ё��yW 'Y1�������)~I�e�V���E�O������+�����\{���ߵ?��r�G���Rp��ߠ�q1�cJT�_
*������?����?�zl hQ�T�e����t���GC�'��]����p�����Q�a	�DX�qX$@H�Ei�$)�����P��/��Ch���2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x������OO����D��_�!���������].����˔����I�Z����Px��e�p��i�@+���ϔ�K�A/�?�bHu����?�>?�IW�?e�K�?K#t�������6�26�R��Q��,��x4B��x���o���FQi(C������1�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���χ����������J��`�{<���c�����z|��P}i�P�2Q��߰�P�|�M x�������1�������]���X��a������g��п�����q�����r1��Zo�H_�����A�;t�z��K��<�Ѓ��v��3q�p�i��N�c1/>�]h����!1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8���u_;s.���k ��ݚ�rnk%ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/������_
~���+���׬���Vn�o�2�������'�RU��R������6���z��ps'���B�ó�ѧ���7���3C��o�<���� �=2|r�����k����&>q[�?�+� �	!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4��=M��|gs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>S����r���*����?�,��:�S�b�W����!��������������_��W������s���aX�����r�_n�]����U�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0���[���a��,��i�������J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C����G����O��%q�_���?������4��b������f���V���2?�N]?��j��/��4�C�[m�O�t�{a��I��k�1�E\���5re/��}z���N�x����&��UM�.�7<�iv�;�]��w�:��OOoL�t����h�$���TVL��^z�j٤v���~z��Q���UQr}ܭ���擟�C���q����_v�OȜW�rj��N?���ڕw�m��D��1��/�������v��k{��ӛ��µo�nnm�ۙ��]����Es���.�7Quй��}CT� �b���>�y���ڗ��h4����l�j*ɝ����@�w�:��4̮o?ʵ�(��˝���{��{~C�˛�Yރ(K��o`t�7��p����"{��[�2iA�ϟ�^ܛ�������8կ��n��z7��5x�����ʾ_���|�[��j�������j���2���'k8�{=��ԅ��z�q������Hj�Z�a�MX�@���)��x���&�f�����pF�=���é��pls�b໺x�7���]A�G"?0DCV�����-��mUqd|_��q��kF�ue���YNw�`�����)�n��ْ�o{W�U������\z;u�r;���[tgo��p
�:N�d'q�����q;�{�|WH$�T$`�"� @� �/@��~�VBˇ�Bh�-Z	�;�'�$3�����+�q��|��}����s�y̘7t+g&
�����-^�Ŧ�9�`b�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɓ���/�e4�"�v��i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;��x��t.?�!h�R:˰�r�;-A�U�|O�B�[�9�&\�f��y��*���4b	�E��?p��m�}|ш_9|�r��xi�Xu�DM�Ԍ[�C�o����h��GS썍��0�u��� mN�����L�:pz68,�)� ��W��?X�i=���:��bg�oj
?�t�ש���G	�y���Q����.�礖����A7�f3i'����	�ӟ��\.7�ˎ(�=��U�E�p?� ede�sKW�5�o��C�<*QAohf�`���\���ՇC�r�.���ǖ/C�*�J�\̔�z��g�>&ׅ�P䦵@٪Fi�:*�n�a� ��,	5:}�%.-��^���:r�h_/����lI�7v�|�s���#�Zj4r�$�Bُۣ%)h��)3�%��t���]fLЊ�-�Y�xڛ�Ń�ht��ܽ�!,�bg�P��d�W�ת�N�.�l��ַ��s�.܁[����1�t�i��M������#�|>y�&�_�:���������������W?�_$�Ӡ�ua���O�������V�O�cuo����CL!>�c�~<Xq/���E<��}��z�G"P�|B|.��>q�����\}{�������=�z����O������ֳ��A�x����|�A��wO�����o�0.�����7��7���_C�p�ܵ��_�x�1,���g�����]i��H7�y����r9��B������� eN��I��di��"�`d��o�1D��=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f����l3�KVLEr�6g��+Q�*�^� �Ch����l��,�gÓ��yr&�J��[�,Er��h��Z����SJ��k4��#%[��������w�����<N��2�*��2<_��!���3�����CFP�r���%�	�0a&�&LX��'"�~�DX�X���m�	����]��[jFHy �=57BֽzD@)�oĳ-�a���'����~�
�W�fRE�F��]��"�K�`�5�X�)8-�t��S
0�:��ܸ�e�l5�r4R�n,���B�������X�����.J��ah�LF0T��^�(f��(W�1:�	��<�0�d#J-�iY��kE߸/Գ�T��%J-)�Gz��@��b�n���+K���e��ʲ����#Z���d�@��GAo�%�Y�8��b}@�� 't��b�G��y�3�E�Q����m&\J2���u1�P�Fu��gN�,$��E��016Z��òl�+����YR�#��k�%���H�<ĳ�1M}1�vJ�*�zz����E�mV&1KYF�z��?�k�0���u&k�B���z�H��P�(Rzm�%�JY�+�ex��47P�8����{5��Ӵ7�)��#O��i�76څ��G�ZV;dil!=Jj�wP�Ƶj�O����JO5�=��D�tCI�b��CU��1.����-)��ٵ��EvQ�8@��=^oY��K(;��A9�hQ<%����-`p� '�� @��F[��R�JM�X���2_�a��ח.�Z�q��v|6�gs|��|��K��3�8���7��n �B�m݉� [�%����;W�7ϿJۙ|`z��@\P��sy��+�y�*+�SU����0�d3Į�������.���6l�G�J��AUi#��~p)��%err�a� 5�)dE��7���5Wս<#v���i"��\UQm7��jM�1�� ����3�|���3.�6�v�\E�l�	���l�ྰI,�J�f�y+r/��~s���f�LO��̞�r�o_�IM�}1������3�bE���";�����č\ �eEҷ�Ύ��O������˟���o#��}X��R�l�R�܉C�d����� ۡ)�����R�
;���o/���t���Hɬ��梃��dа��{8��`�+G�9��Z,Oc�Ysȃ��{��A��T��c
퍙]�5,�~���4"�+�>΅���j�T'��#X#�A��R*,��%��RċйM7ٴ!T��8\cI��ʑ�=�8֚dL�=!ca)k�ӧ13�%�!{���JD��bz���ן���D�����5
4�J�8�d�b���P�ԒAm��h���|ԇuP���7�F`\l펇#c��B�$�pG��hӋ�n�D }�F�j���R�(�	=�8܎q8���	~���Kzyt*�:�\^6���c2�c�3m��=�G�����s�E.�}ޙ��=���n����1���'�������r"io�Hڦ�Hn.8·*�Z��H]Hs�&��GĒ��|�����b�GkQ�I�`����D�Y�"�V�IPd�Ys�5�+�w��Nok)B�hI9B��Q8�ΐ������0.z��p4����!$��j}mE��둪�GG�a �f+cR4^������Cc!T��_DA��)��+m��hg_�{R�~�Em��_�Y:(W�7&���W252-��Ru�y.�1�|<�rpak{ji����rjO!т�<-�f����i��hVh�إ�7���p����8N��x#~9e�S;e96}m�� ̶s<h��"|�����H����=݊n����ķ�M�V�E��k��{����u�=-�T$ނ�Fd\��I�?p���z呥8��$�<."�;l7�&��]���O^�����c��?�◞��w|���>��� �����VW��|7'-���Ϲ�����������-	�w\_��}�)����.�GF��d�'?������Of�F��E�ߓ�KI��$���4�~�W�rW4&Ӊ5d�����|߻��h�?������Ǒ_|�_?��G~À��W��9j����ˋ��_:�N���P;��Cp���W���W\' ��j�C�t������l�j�����z���Mh�Ap�2C�\���m�����@=�x�9Cg}�������#/�Q^@����9<�S��)��8���k�38G����Af�����٬�93N�ՙ3�Lp�8sf�p��6̙9�|�3L��3sn�w���Mi��.y�ɜ��/�;h�1��$'9�INzݦ��D�b  