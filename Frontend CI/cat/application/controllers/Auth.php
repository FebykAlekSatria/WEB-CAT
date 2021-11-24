<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Auth extends CI_Controller
{
    public function index()
    {
        $this->form_validation->set_rules('username', 'Username', 'trim|required');
        $this->form_validation->set_rules('pin', 'Pin', 'trim|required');
        $this->form_validation->set_rules('password', 'Password', 'trim|required');
        if ($this->form_validation->run() == false) {
            $this->load->view('auth/loginPeserta');
        } else {
            $this->_loginPeserta();
        }
    }
    private function _loginPeserta()
    {
        $username = $this->input->post('username');
        $sesi = $this->input->post('pin');
        $password = $this->input->post('password');
        $cek = $this->db->query("call verify_login_user('$username','$sesi','$password')")->num_rows();
        $this->db->reconnect();
        $result = $this->db->query("call verify_login_user('$username','$sesi','$password')")->result_array();
        $this->db->reconnect();
        $check = $this->db->query("call is_ujian_berlangsung('$sesi')")->result_array();
        $this->db->reconnect();
        if(!empty($result)){
			$id_p = $result[0]['peserta_id'];
			$id_s = $result[0]['sesi_id'];
        }
        $np = $this->db->query("call get_detail_ujian('$id_p','$id_s')")->result_array();
        if(!empty($np)){
			$no_p = $np[0]['no_peserta'];
        }
        $this->db->reconnect();
        $is_done = $this->db->query("call is_ujian_done('$no_p')")->result_array();
        if ($cek > 0) {
			if($check[0]['RESULT'] == 1){
				if ($is_done[0]['RESULT'] == 0) {
					$data_session = array(
						'sesi_id' => $result[0]['sesi_id'],
						'user_id' => $result[0]['peserta_id'],
						'status' => "login"
					);
					$this->session->set_userdata('data_user', $data_session);
					redirect('peserta');
				} else {
					$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
					Anda Telah Menyelesaikan Ujian
					</div>');
					redirect('auth');
				}
			} else {
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
				Sesi Telah Berakhir
				</div>');
				redirect('auth');
			}
        } else {
            $this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
            Gagal Login
            </div>');
            redirect('auth');
        }
    }
    public function loginAdmin()
    {
        $this->form_validation->set_rules('username', 'Username', 'trim|required');
        $this->form_validation->set_rules('password', 'Password', 'trim|required');
        if ($this->form_validation->run() == false) {
            $this->load->view('auth/login');
        } else {
            $this->_login();
        }
    }
    private function _login()
    {
        $username = $this->input->post('username');
        $password = $this->input->post('password');
        $cek = $this->db->query("call verify_login_admin('$username','$password')")->row();
        if ($cek > 0) {
            $id = $cek->id;
            $data_session = array(
                'nama' => $username,
                'id' => $id,
                'status' => "login"
            );

            $this->session->set_userdata('data', $data_session);
            redirect('admin');
        } else {
            $this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
            Username atau Password salah
            </div>');
            redirect('auth/loginadmin');
        }
    }

    public function logout()
    {
        // $this->session->unset_userdata('data');
        $this->session->sess_destroy();
        $this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
            anda berhasil logout
            </div>');
        redirect('auth/loginadmin');
    }
}
