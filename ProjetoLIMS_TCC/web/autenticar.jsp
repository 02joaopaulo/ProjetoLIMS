<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");

    try {
        // Criptografar a senha usando SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(senha.getBytes("UTF-8"));
        String senhaCriptografada = Base64.getEncoder().encodeToString(hashBytes);

        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

        // Verificar as credenciais do usuário (com senha criptografada)
        st = conecta.prepareStatement("SELECT idusuario, idperfil FROM usuario WHERE usuario=? AND senha=?");
        st.setString(1, usuario);
        st.setString(2, senhaCriptografada); // Comparar com a senha criptografada armazenada no banco
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            int idPerfil = rs.getInt("idperfil");

            // Obter as telas de acesso do perfil
            st = conecta.prepareStatement("SELECT telasdeacesso FROM perfil WHERE idperfil=?");
            st.setInt(1, idPerfil);
            ResultSet rsPerfil = st.executeQuery();

            if (rsPerfil.next()) {
                String telasDeAcesso = rsPerfil.getString("telasdeacesso");
                List<String> telas = new ArrayList<>();
                for (String tela : telasDeAcesso.split(",")) {
                    telas.add(tela.trim());
                }

                // Configurar os atributos na sessão
                session.setAttribute("usuario", usuario);
                session.setAttribute("telas", telas);
                response.sendRedirect("menu.jsp"); // Redirecionar para o menu principal
            } else {
                out.println("Perfil não encontrado.");
            }
        } else {
            out.println("Usuário ou senha inválidos.");
        }

        // Fechar a conexão
        st.close();
        conecta.close();
    } catch (Exception e) {
        out.print("Erro na transmissão para o MySQL: " + e.getMessage());
        e.printStackTrace();
    }
%>
