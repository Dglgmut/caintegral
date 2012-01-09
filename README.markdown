#Site para o centro academico da Fatec-sp
Toda mudança positiva de codigo será bem vinda :)


Iniciando
====================
Para começar a desenvolver é necessario ter a versão 1.9.2 do ruby, que pode ser obtido no link: http://www.ruby-lang.org/pt/

Também é necessario ter o postgresql; http://www.enterprisedb.com/products/pgdownload.do#windows

Dentro do Postgresql rode os comandos que cria um Role e um banco de dados;

	CREATE ROLE myapp WITH
	CREATEDB LOGIN PASSWORD 'myapp';
	CREATE DATABASE dev_integral OWNER myapp;
	\q

Para baixar a aplicação usando o git rode esse comando do seu terminal(cmd);

	git clone git://github.com/Dglgmut/caintegral.git


Após criar o banco de dados, instalar o ruby e baixar a aplicação;

	cd caintegral
	bundle install
	ruby app.rb

Vá para http://localhost:4567 e você deverá ver a tela inicial do sistema.

Qualquer problema; https://github.com/Dglgmut/caintegral/issues/new

Arquitetura da aplicação
====================
A aplicação está seguindo a arquitetura MVC de uma maneira meio estranha, isso será ajustado em breve,

descrição do papel de cada arquivo;
-----------------------------------
app.rb - Aqui está definida a logica de todo o sistema, banco de dados, requests, etc... (esse arquivo será descentralizado com o tempo)
views/ pasta com todos os arquivos em HAML.
public/ pasta com javascript/css (será convertido para coffeescript/sass)
lib/ possui helpers e metodos em geral
tasks/ tarefas que o sistema pode realizar como migrações, compilação de coffeescript, etc..

TODO
====================

* Criar inteface que le o twitter
* Ajustar o sistema de layout, usando um layout unico
* Quando der um erro de validação na submissão de formularios voltar o valor dos inputs
* Criar um sistema de migration mais solido, auto_migrate! apaga todos os dados e o auto_upgrade! não da conta de mudar tudo :(
