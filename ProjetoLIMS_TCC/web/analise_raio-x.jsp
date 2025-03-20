<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Análise de Raio-X</title>
    <link rel="stylesheet" href="css/usuario.css"/>
    <script>
        function calcularRaioX() {
            const fe = parseFloat(document.getElementById("fe").value);
            const sio2 = parseFloat(document.getElementById("sio2").value);
            const al2o3 = parseFloat(document.getElementById("al2o3").value);
            const p = parseFloat(document.getElementById("p").value);
            const mn = parseFloat(document.getElementById("mn").value);

            if (!isNaN(fe) && !isNaN(sio2) && !isNaN(al2o3) && !isNaN(p) && !isNaN(mn)) {
                document.getElementById("resultado_fe").textContent = fe.toFixed(2);
                document.getElementById("resultado_sio2").textContent = sio2.toFixed(2);
                document.getElementById("resultado_al2o3").textContent = al2o3.toFixed(2);
                document.getElementById("resultado_p").textContent = p.toFixed(2);
                document.getElementById("resultado_mn").textContent = mn.toFixed(2);
                document.getElementById("btnSalvar").disabled = false;
            } else {
                alert("Por favor, preencha todos os campos de entrada.");
            }
        }
    </script>
</head>
<body>
    <div class="form-container">
        <div class="form-box">
            <form method="post" action="salvar_analise_raiox.jsp">
                <h2>Identificação:</h2>
                <label for="idamostra">ID Amostra:</label>
                <input type="text" name="idamostra" id="idamostra" value="<%= request.getParameter("idamostra") %>" readonly>
                
                <h2>Dados de Entrada:</h2>
                <label for="fe">Fe:</label>
                <input type="number" name="fe" id="fe" step="0.01" required>
                
                <label for="sio2">SiO2:</label>
                <input type="number" name="sio2" id="sio2" step="0.01" required>
                
                <label for="al2o3">Al2O3:</label>
                <input type="number" name="al2o3" id="al2o3" step="0.01" required>
                
                <label for="p">P:</label>
                <input type="number" name="p" id="p" step="0.001" required>
                
                <label for="mn">Mn:</label>
                <input type="number" name="mn" id="mn" step="0.001" required>
                
                <button type="button" onclick="calcularRaioX()">Calcular</button>
                
                <h2>Resultados:</h2>
                <p>Fe: <span id="resultado_fe">0.00</span></p>
                <p>SiO2: <span id="resultado_sio2">0.00</span></p>
                <p>Al2O3: <span id="resultado_al2o3">0.00</span></p>
                <p>P: <span id="resultado_p">0.000</span></p>
                <p>Mn: <span id="resultado_mn">0.000</span></p>
                
                <h2>Liberação:</h2>
                <label for="responsavelanalise">Responsável pela Análise:</label>
                <select name="responsavelanalise" id="responsavelanalise" required>
                    <%
                        Connection conecta = null;
                        PreparedStatement st = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                            st = conecta.prepareStatement("SELECT usuario FROM usuario WHERE perfil = 'analista'");
                            rs = st.executeQuery();
                            while (rs.next()) {
                                String usuario = rs.getString("usuario");
                    %>
                    <option value="<%= usuario %>"><%= usuario %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.print("Erro ao consultar usuários: " + e.getMessage());
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (st != null) st.close();
                            if (conecta != null) conecta.close();
                        }
                    %>
                </select>
                
                <button type="submit" id="btnSalvar" disabled>Salvar</button>
            </form>
        </div>
    </div>
</body>
</html>
