<?php
defined('BASEPATH') or exit('No direct script access allowed');
class Admin extends CI_Controller
{
    public function index()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/admin');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function soal()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/soal');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function kategori()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/kategori');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function tambahSoal()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/addSoal');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function editSoal()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/editSoal');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function peserta()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/peserta');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function jadwal()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/jadwal');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function tambahSesi()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->form_validation->set_rules('name', 'Name', 'trim|required');
            $this->form_validation->set_rules('address', 'Address', 'trim|required');
            $this->form_validation->set_rules('date', 'Date', 'trim|required');
            $this->form_validation->set_rules('time', 'Time', 'trim|required');
            $this->form_validation->set_rules('totalSoal', 'TotalSoal', 'trim|required');
            $this->form_validation->set_rules('totalPeserta', 'TotalPeserta', 'trim|required');
            $this->form_validation->set_rules('score', 'Score', 'trim|required');
            if ($this->form_validation->run() == false) {
                // $this->load->view('auth/login');
                $this->load->view('template/head');
                $this->load->view('template/sidebar');
                $this->load->view('template/topbar');
                $this->load->view('admin/addSesi');
                $this->load->view('template/tail');
            } else {
            }
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function tambahPesertaSesi()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/addPesertasesi');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function pesertasesi()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/listPesertaSesi');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function tambahSoalSesi()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/addSoalSesi');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function editSesi()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/editSesi');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function nilai()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $id = $this->input->post('idKategori');
            $data['id'] = $id;
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/nilai', $data);
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
    public function detailNilai()
    {
        $data = $this->session->userdata('data');
        if (!empty($data)) {
            $this->load->view('template/head');
            $this->load->view('template/sidebar');
            $this->load->view('template/topbar');
            $this->load->view('admin/detailNilai');
            $this->load->view('template/tail');
        } else {
            redirect('auth/loginadmin');
        }
    }
}
