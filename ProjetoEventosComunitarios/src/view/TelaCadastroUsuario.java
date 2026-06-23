package view;

import dao.UsuarioDAO;
import model.Usuario;

import javax.swing.*;

public class TelaCadastroUsuario extends JFrame {

    private JTextField nome, email, cpf, telefone;
    private JPasswordField senha;
    private JComboBox<String> tipo;
    private JButton salvar;

    public TelaCadastroUsuario() {

        setTitle("Cadastro de Usuário");
        setSize(400, 400);
        setLayout(null);
        setLocationRelativeTo(null);

        nome = new JTextField();
        email = new JTextField();
        senha = new JPasswordField();
        cpf = new JTextField();
        telefone = new JTextField();

        tipo = new JComboBox<>(new String[]{
            "ORGANIZADOR", "VOLUNTARIO", "PUBLICO"
        });

        salvar = new JButton("Salvar");

        addLabel("Nome:", 20, 20);
        nome.setBounds(150, 20, 200, 25);
        add(nome);

        addLabel("Email:", 20, 60);
        email.setBounds(150, 60, 200, 25);
        add(email);

        addLabel("Senha:", 20, 100);
        senha.setBounds(150, 100, 200, 25);
        add(senha);

        addLabel("CPF:", 20, 140);
        cpf.setBounds(150, 140, 200, 25);
        add(cpf);

        addLabel("Telefone:", 20, 180);
        telefone.setBounds(150, 180, 200, 25);
        add(telefone);

        addLabel("Tipo:", 20, 220);
        tipo.setBounds(150, 220, 200, 25);
        add(tipo);

        salvar.setBounds(120, 280, 150, 40);
        add(salvar);

        salvar.addActionListener(e -> salvar());
    }

    private void salvar() {

        // ✅ REGRA: campos obrigatórios
        if (nome.getText().isEmpty() || email.getText().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Preencha nome e email!");
            return;
        }

        Usuario u = new Usuario();
        u.setNome(nome.getText());
        u.setEmail(email.getText());
        u.setSenha(new String(senha.getPassword()));
        u.setCpf(cpf.getText());
        u.setTelefone(telefone.getText());
        u.setTipoUsuario(tipo.getSelectedItem().toString());

        new UsuarioDAO().criar(u);

        JOptionPane.showMessageDialog(null, "Usuário cadastrado!");
    }

    private void addLabel(String texto, int x, int y) {
        JLabel l = new JLabel(texto);
        l.setBounds(x, y, 120, 20);
        add(l);
    }
}