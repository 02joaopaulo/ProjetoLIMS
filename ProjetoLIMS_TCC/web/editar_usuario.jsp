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
        <title>Editar Usuário</title>
    </head>
    <body>
        <div class="form-container">
            <div class="form-box">
                <form action="atualizar_usuario.jsp" method="post">
                    <input type="hidden" id="editIdUsuario" name="idusuario" value="<%= request.getParameter("idusuario") %>">
                    <label for="editUsuario">Usuário:</label>
                    <input type="text" id="editUsuario" name="usuario" value="<%= request.getParameter("usuario") %>" required>
                    <label for="editSenha">Senha:</label>
                    <input type="password" id="editSenha" name="senha" value="<%= request.getParameter("senha") %>" required>
                    <label for="editPerfil">Perfil:</label>
                    <select id="editPerfil" name="perfil" required>
                        <%
                            Connection conecta;
                            PreparedStatement stPerfil;
                            ResultSet rsPerfil;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                                stPerfil = conecta.prepareStatement("SELECT perfil FROM perfil");
                                rsPerfil = stPerfil.executeQuery();
                                while (rsPerfil.next()) {
                                    String perfil = rsPerfil.getString("perfil");
                        %>
                        <option value="<%= perfil %>" <%= perfil.equals(request.getParameter("perfil")) ? "selected" : "" %>><%= perfil %></option>
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
                    <button type="submit">Salvar</button>
                </form>
            </div>
        </div>
    </body>
</html>