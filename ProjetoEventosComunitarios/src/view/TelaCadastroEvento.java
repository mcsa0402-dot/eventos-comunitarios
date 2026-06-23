package view;

import dao.EventoDAO;
import model.Evento;

import javax.swing.*;
import java.time.LocalDateTime;

public class TelaCadastroEvento extends JFrame {

    private JTextField titulo, descricao, data, hora, capacidade;

    public TelaCadastroEvento() {

        setTitle("Cadastro de Evento");
        setSize(400, 400);
        setLayout(null);
        setLocationRelativeTo(null);

        titulo = new JTextField();
        descricao = new JTextField();
        data = new JTextField();
        hora = new JTextField();
        capacidade = new JTextField();

        JButton salvar = new JButton("Salvar");

        addLabel("Título:", 20, 20);
        titulo.setBounds(120, 20, 200, 25);
        add(titulo);

        addLabel("Descrição:", 20, 60);
        descricao.setBounds(120, 60, 200, 25);
        add(descricao);

        addLabel("Data (YYYY-MM-DD):", 20, 100);
        data.setBounds(120, 100, 200, 25);
        add(data);

        addLabel("Hora (HH:MM):", 20, 140);
        hora.setBounds(120, 140, 200, 25);
        add(hora);

        addLabel("Capacidade:", 20, 180);
        capacidade.setBounds(120, 180, 200, 25);
        add(capacidade);

        salvar.setBounds(120, 240, 150, 40);
        add(salvar);

        salvar.addActionListener(e -> salvar());
    }

    private void salvar() {

        try {

            // ✅ REGRA: campos obrigatórios
            if (titulo.getText().isEmpty() || data.getText().isEmpty() || hora.getText().isEmpty()) {
                JOptionPane.showMessageDialog(null, "Preencha todos os campos!");
                return;
            }

            String dataHoraTexto = data.getText() + "T" + hora.getText();

            Evento ev = new Evento();
            ev.setTitulo(titulo.getText());
            ev.setDescricao(descricao.getText());
            ev.setDataHora(LocalDateTime.parse(dataHoraTexto));
            ev.setCapacidade(Integer.parseInt(capacidade.getText()));

            // ✅ REGRA EXTRA: não permitir data passada
            if (ev.getDataHora().isBefore(LocalDateTime.now())) {
                JOptionPane.showMessageDialog(null, "Data no passado não permitida!");
                return;
            }

            ev.setIdLocal(1);
            ev.setIdCategoria(1);
            ev.setIdOrganizador(1);
            ev.setStatus("ABERTO");

            new EventoDAO().criar(ev);

            JOptionPane.showMessageDialog(null, "Evento criado!");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro nos dados!");
        }
    }

    private void addLabel(String texto, int x, int y) {
        JLabel l = new JLabel(texto);
        l.setBounds(x, y, 200, 20);
        add(l);
    }
}