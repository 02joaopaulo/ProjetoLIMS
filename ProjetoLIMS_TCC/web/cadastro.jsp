<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/usuario.css"/>
        <title>Cadastro</title>
    </head>
    <body>
        <div class="form-container">
            <div class="form-box">
                <form method="post" action="salvar_cadastro.jsp">
                    <label for="nomeamostra">Nome Amostra:</label>
                    <input type="text" name="nomeamostra" id="nomeamostra" maxlength="50" required>
                    
                    <label for="datahoraamostra">Data/Hora Amostra:</label>
                    <input type="datetime-local" name="datahoraamostra" required>
                    
                    <label for="cliente">Cliente:</label>
                    <select name="cliente" id="cliente" required>
                        <option value="">Selecione um cliente</option>
                        <%
                            try {
                                // Conectar ao banco de dados
                                Connection conecta;
                                PreparedStatement st;
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                                // Consultar os clientes no banco de dados
                                st = conecta.prepareStatement("SELECT usuario FROM usuario WHERE perfil = 'cliente'");
                                ResultSet rs = st.executeQuery();

                                // Preencher o campo select com os clientes
                                while (rs.next()) {
                                    String cliente = rs.getString("usuario");
                        %>
                                    <option value="<%= cliente %>"><%= cliente %></option>
                        <%
                                }
                                rs.close();
                                st.close();
                                conecta.close();
                            } catch (Exception e) {
                                out.print("Erro na transmissão para o mySQL: " + e.getMessage());
                                e.printStackTrace();
                            }
                        %>
                    </select>
                    
                    <label for="analise">Análise:</label>
                    <select name="analise" id="analise" required>
                        <option value="umidade">Umidade</option>
                        <option value="raio-x">Raio-x</option>
                        <option value="ppc">PPC</option>
                    </select>
                    
                    <button type="submit">Salvar</button>
                </form>
            </div>
        </div>
    </body>
</html>