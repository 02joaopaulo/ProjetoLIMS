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
        <title>Criar Usuário</title>
    </head>
    <body>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Inserir novo usuário no banco de dados
                    String usuario = request.getParameter("usuario");
                    String senha = request.getParameter("senha");
                    String perfil = request.getParameter("perfil");

                    // Obter o idperfil correspondente ao perfil selecionado
                    PreparedStatement stPerfil = conecta.prepareStatement("SELECT idperfil FROM perfil WHERE perfil = ?");
                    stPerfil.setString(1, perfil);
                    ResultSet rsPerfil = stPerfil.executeQuery();
                    int idperfil = 0;
                    if (rsPerfil.next()) {
                        idperfil = rsPerfil.getInt("idperfil");
                    }

                    st = conecta.prepareStatement("INSERT INTO usuario (usuario, senha, perfil, idperfil) VALUES (?, ?, ?, ?)");
                    st.setString(1, usuario);
                    st.setString(2, senha);
                    st.setString(3, perfil);
                    st.setInt(4, idperfil);
                    st.executeUpdate();

                    // Fechar a conexão
                    st.close();
                    conecta.close();

                    // Redirecionar para a tela de usuários
                    response.sendRedirect("usuarios.jsp");
                } catch (Exception e) {
                    out.print("Erro ao criar usuário: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                // Consultar perfis disponíveis
                Connection conecta;
                PreparedStatement stPerfil;
                ResultSet rsPerfil;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                    stPerfil = conecta.prepareStatement("SELECT perfil FROM perfil");
                    rsPerfil = stPerfil.executeQuery();
        %>
        <div class="form-container">
            <div class="form-box">
                <form action="criar_usuario.jsp" method="post">
                    <label for="usuario">Usuário:</label>
                    <input type="text" id="usuario" name="usuario" required>
                    <label for="senha">Senha:</label>
                    <input type="password" id="senha" name="senha" required>
                    <label for="perfil">Perfil:</label>
                    <select id="perfil" name="perfil" required>
                        <%
                            while (rsPerfil.next()) {
                                String perfil = rsPerfil.getString("perfil");
                        %>
                        <option value="<%= perfil %>"><%= perfil %></option>
                        <%
                            }
                            rsPerfil.close();
                            stPerfil.close();
                            conecta.close();
                        } catch (Exception e) {
                            out.print("Erro ao consultar perfis: " + e.getMessage());
                            e.printStackTrace();
                        }
                        %>
                    </select>
                    <button type="submit">Criar</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>