<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Peserta extends CI_Controller
{
    public function index()
    {
        $this->load->view('peserta/detailPeserta');
    }
    public function Soal()
    {
        $soal_id = $this->session->userdata('soal_id');
        $no_p = $this->session->userdata('no_peserta');
        if (!empty($this->input->post('jawaban'))) {
            $jawaban = $this->input->post('jawaban');
        } else if (!empty($this->input->post('jawaban1'))) {
            $jawaban = $this->input->post('jawaban1');
        } else {
            $jawaban = "";
        }
        $data = $this->input->post('pilih_soal');
        $idx_ds = $this->input->post('idx');
        if ($data > 0) {
            $arr['id'] = $data;
        } else {
            $arr['id'] = 0;
        }
        if (!empty($idx_ds)) {
            $idx = $idx_ds;
        } else {
            $idx = $this->session->userdata('idx');
        }
        $arr['coba'] = $jawaban;
        if (!empty($jawaban)) {
            $check = $this->db->query("call add_jawaban_peserta('$no_p','$soal_id[$idx]','$jawaban')");
            $calculate = $this->db->query("call calculate_nilai('$no_p','$soal_id[$idx]')");
        }
        $this->load->view('peserta/soal', $arr);
    }
    public function Hasil()
    {
        $this->load->view('peserta/hasil');
    }
}
