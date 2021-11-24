<?php
defined('BASEPATH') or exit('No direct script access allowed');

class ImportModel extends CI_Model
{

	public function insert_peserta($data)
	{
		foreach ($data as $value) {
			$id = $value['id'];
			$username = $value['username'];
			$password = $value['password'];
			$nama = $value['nama'];
			$asal_sekolah = $value['asal'];
			$no_hp = $value['no_hp'];
			$this->db->reconnect();
			$username_check = $this->db->query("call is_username_exists('$username')")->result_array();
			if ($username_check[0]['RESULT'] == '0') {
				$this->db->reconnect();
				$insert = $this->db->query("call add_peserta('$id','$username','$password','$nama','$asal_sekolah','$no_hp')");
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Peserta berhasil ditambah
			</div>');
			} else {
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Username sudah terdaftar
			</div>');
			}
		}
		if ($insert) {
			return true;
		}
	}
	public function insert_peserta_to_sesi($data)
	{
		foreach ($data as $value) {
			$no_p = $value['no_peserta'];
			$pin_sesi = $value['pin_sesi'];
			$id = $value['user_id'];
			$username = $value['username'];
			$password = $value['password'];
			$nama = $value['nama'];
			$asal_sekolah = $value['asal'];
			$no_hp = $value['no_hp'];

			$this->db->reconnect();
			$insert = $this->db->query("call import_excel_peserta_sesi('$pin_sesi','$nama','$username','$password','$no_hp','$asal_sekolah','$no_p','$id')");
			$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Peserta berhasil ditambah
			</div>');
		}
		if ($insert) {
			return true;
		}
	}
	public function insert_soal($data)
	{
		foreach ($data as $value) {
			$id_s = $value['id_s'];
			$kategori = $value['kategori'];
			$soal = $value['soal'];
			$gambar = $value['gambar'];
			$opsi_a = $value['opsi_a'];
			$opsi_b = $value['opsi_b'];
			$opsi_c = $value['opsi_c'];
			$opsi_d = $value['opsi_d'];
			$opsi_e = $value['opsi_e'];
			$bobot_a = $value['bobot_a'];
			$bobot_b = $value['bobot_b'];
			$bobot_c = $value['bobot_c'];
			$bobot_d = $value['bobot_d'];
			$bobot_e = $value['bobot_e'];
			$kunci = $value['kunci'];
			$insert = $this->db->query("call add_soal('$id_s','$kategori','$soal','$gambar','$opsi_a','$opsi_b','$opsi_c','$opsi_d','$opsi_e','$kunci','$bobot_a','$bobot_b','$bobot_c','$bobot_d','$bobot_e')");
		}
		if ($insert) {
			return true;
		}
	}
	public function getData()
	{
		$this->db->select('*');
		return $this->db->get('peserta')->result_array();
	}
}
