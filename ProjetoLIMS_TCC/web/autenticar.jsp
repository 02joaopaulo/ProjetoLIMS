<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");

    try {
        // Criptografar a senha usando SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(senha.getBytes("UTF-8"));
        String senhaCriptografada = Base64.getEncoder().encodeToString(hashBytes);

        // Conectar ao banco de dados
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos")) {
            // Verificar as credenciais do usuário
            String sqlUsuario = "SELECT idusuario, idperfil FROM usuario WHERE usuario=? AND senha=?";
            try (PreparedStatement st = conecta.prepareStatement(sqlUsuario)) {
                st.setString(1, usuario);
                st.setString(2, senhaCriptografada);
                ResultSet rs = st.executeQuery();

                if (rs.next()) {
                    int idPerfil = rs.getInt("idperfil");

                    // Obter as telas de acesso do perfil
                    String sqlPerfil = "SELECT telasdeacesso FROM perfil WHERE idperfil=?";
                    try (PreparedStatement stPerfil = conecta.prepareStatement(sqlPerfil)) {
                        stPerfil.setInt(1, idPerfil);
                        ResultSet rsPerfil = stPerfil.executeQuery();

                        if (rsPerfil.next()) {
                            String telasDeAcesso = rsPerfil.getString("telasdeacesso");
                            List<String> telas = new ArrayList<>();
                            for (String tela : telasDeAcesso.split(",")) {
                                telas.add(tela.trim());
                            }

                            // Configurar os atributos na sessão
                            session.setAttribute("usuario", usuario);
                            session.setAttribute("telas", telas);
                            session.setAttribute("perfil", idPerfil);

                            // Registrar no log
                            String sqlLog = "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement stLog = conecta.prepareStatement(sqlLog)) {
                                stLog.setString(1, "Login");
                                stLog.setString(2, "Efetuado o login pelo usuário " + usuario);
                                stLog.setString(3, usuario);
                                stLog.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
                                stLog.executeUpdate();
                            }

                            response.sendRedirect("menu.jsp");
                        } else {
                            out.println("Perfil não encontrado.");
                        }
                    }
                } else {
                    out.println("Usuário ou senha inválidos.");
                }
            }
        }
    } catch (Exception e) {
        out.print("Erro na transmissão para o MySQL: " + e.getMessage());
        e.printStackTrace();
    }
%>
