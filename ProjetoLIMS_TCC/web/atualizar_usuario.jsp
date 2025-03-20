<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Atualizar Usuário</title>
    </head>
    <body>
        <%
            try {
                // Parâmetros recebidos do formulário de edição
                String idUsuario = request.getParameter("idusuario");
                String usuario = request.getParameter("usuario");
                String senha = request.getParameter("senha");
                String perfil = request.getParameter("perfil");

                // Conectar ao banco de dados
                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                // Atualizar os dados no banco de dados
                String sql = "UPDATE usuario SET usuario = ?, senha = ?, perfil = ? WHERE idusuario = ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, usuario);
                st.setString(2, senha);
                st.setString(3, perfil);
                st.setString(4, idUsuario);
                int rowsUpdated = st.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("usuarios.jsp"); // Redirecionar para a tela de consulta de usuários
                } else {
                    out.print("Falha ao atualizar o usuário.");
                }

                // Fechar a conexão
                st.close();
                conecta.close();
            } catch (Exception e) {
                out.print("Erro na atualização do usuário: " + e.getMessage());
                e.printStackTrace();
            }
        %>
    </body>
</html>
