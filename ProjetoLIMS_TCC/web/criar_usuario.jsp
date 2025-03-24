<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Base64"%>
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

                    // Obter os parâmetros fornecidos pelo usuário
                    String usuario = request.getParameter("usuario");
                    String senha = request.getParameter("senha");
                    String perfil = request.getParameter("perfil");

                    // Gerar o hash da senha utilizando SHA-256
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] hashBytes = md.digest(senha.getBytes("UTF-8"));
                    String senhaHash = Base64.getEncoder().encodeToString(hashBytes);

                    // Obter o idperfil correspondente ao perfil selecionado
                    PreparedStatement stPerfil = conecta.prepareStatement("SELECT idperfil FROM perfil WHERE perfil = ?");
                    stPerfil.setString(1, perfil);
                    ResultSet rsPerfil = stPerfil.executeQuery();
                    int idperfil = 0;
                    if (rsPerfil.next()) {
                        idperfil = rsPerfil.getInt("idperfil");
                    }

                    // Inserir o novo usuário no banco de dados com a senha criptografada
                    st = conecta.prepareStatement("INSERT INTO usuario (usuario, senha, perfil, idperfil) VALUES (?, ?, ?, ?)");
                    st.setString(1, usuario);
                    st.setString(2, senhaHash); // Armazenar o hash da senha
                    st.setString(3, perfil);
                    st.setInt(4, idperfil);
                    st.executeUpdate();

                    // Fechar conexões e redirecionar para a tela de usuários
                    st.close();
                    conecta.close();
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
                    <input type="text" id="usuario" name="usuario" placeholder="Digite seu usuário" required>
                    <label for="senha">Senha:</label>
                    <input type="password" id="senha" name="senha" placeholder="Digite sua senha" required minlength="8">
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
