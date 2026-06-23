package view;

import connection.ConnectionFactory;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TelaInscricao extends JFrame {

    private JTextField email;
    private JComboBox<String> evento;
    private JButton inscrever;

    public TelaInscricao() {

        setTitle("Inscrição");
        setSize(350, 250);
        setLayout(new GridLayout(4, 2, 10, 10));
        setLocationRelativeTo(null);

        email = new JTextField();
        evento = new JComboBox<>();
        inscrever = new JButton("Inscrever");

        carregarEventos();

        add(new JLabel("Email:"));
        add(email);

        add(new JLabel("Evento:"));
        add(evento);

        add(new JLabel(""));
        add(new JLabel(""));

        add(new JLabel(""));
        add(inscrever);

        inscrever.addActionListener(e -> inscrever());
    }

    private void carregarEventos() {

        try (Connection conn = ConnectionFactory.getConnection()) {

            String sql = "SELECT id_evento, titulo FROM evento";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();

            while (rs.next()) {
                evento.addItem(rs.getInt("id_evento") + " - " + rs.getString("titulo"));
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    private void inscrever() {

        try (Connection conn = ConnectionFactory.getConnection()) {

            if (email.getText().isEmpty()) {
                JOptionPane.showMessageDialog(null, "Digite seu email!");
                return;
            }

            // ✅ buscar usuário
            String sqlUser = "SELECT id_usuario FROM usuario WHERE email=?";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setString(1, email.getText());

            ResultSet rsUser = stmtUser.executeQuery();

            if (!rsUser.next()) {
                JOptionPane.showMessageDialog(null, "Usuário não encontrado!");
                return;
            }

            int idUsuario = rsUser.getInt("id_usuario");

            int idEvento = Integer.parseInt(evento.getSelectedItem().toString().split("-")[0].trim());

            // ✅ REGRA 1: duplicada
            String verificar = "SELECT * FROM inscricao WHERE id_usuario=? AND id_evento=?";
            PreparedStatement stmtVer = conn.prepareStatement(verificar);

            stmtVer.setInt(1, idUsuario);
            stmtVer.setInt(2, idEvento);

            if (stmtVer.executeQuery().next()) {
                JOptionPane.showMessageDialog(null, "Você já está inscrito!");
                return;
            }

            // ✅ REGRA 2: lotação
            String check = "SELECT capacidade, (SELECT COUNT(*) FROM inscricao WHERE id_evento=?) as total FROM evento WHERE id_evento=?";
            PreparedStatement stmtCheck = conn.prepareStatement(check);

            stmtCheck.setInt(1, idEvento);
            stmtCheck.setInt(2, idEvento);

            ResultSet rsCheck = stmtCheck.executeQuery();

            if (rsCheck.next()) {
                if (rsCheck.getInt("total") >= rsCheck.getInt("capacidade")) {
                    JOptionPane.showMessageDialog(null, "Evento lotado!");
                    return;
                }
            }

            // ✅ inserir
            String insert = "INSERT INTO inscricao (id_usuario, id_evento) VALUES (?, ?)";
            PreparedStatement stmtInsert = conn.prepareStatement(insert);

            stmtInsert.setInt(1, idUsuario);
            stmtInsert.setInt(2, idEvento);
            stmtInsert.executeUpdate();

            JOptionPane.showMessageDialog(null, "Inscrição realizada!");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }
}