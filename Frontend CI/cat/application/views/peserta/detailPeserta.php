<?php
setcookie('myJavascriptVar', false);
$sesi = $this->session->userdata('data_user');
$this->session->set_userdata('idx', 0);
$id_p = $sesi['user_id'];
$id_s = $sesi['sesi_id'];
if (!empty($this->session->userdata('soal_id'))) {
    redirect('peserta/soal');
}
$result = $this->db->query("call generate_soal_list('$id_s')")->result_array();
$i = 0;
if (empty($result)) {
    $this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
    Soal tidak tersedia untuk sesi ini silahkan hubungi admin
    </div>');
    redirect('auth');
}
foreach ($result as $row) {
    $soal_id[$i++] = $row['soal_id'];
}
$this->session->set_userdata('soal_id', $soal_id);
$this->db->reconnect();
$result = $this->db->query("call get_detail_ujian('$id_p','$id_s')")->result_array();
$this->session->set_userdata('no_peserta', $result[0]['no_peserta']);
if (!empty($result)) {
    $nama = $result[0]['nama'];
    $no_p = $result[0]['no_peserta'];
    $asal_s = $result[0]['asal_sekolah'];
    $no_hp = $result[0]['no_hp'];
    $nama_ujian = $result[0]['nama_ujian'];
    $waktu_mulai = $result[0]['waktu_mulai'];
    $durasi = $result[0]['durasi'];
    $score = $result[0]['passing_grade'];
    $waktu_selesai = $result[0]['waktu_selesai'];
    $this->session->set_userdata('sesi', $waktu_selesai);
    $this->session->set_userdata('score', $result[0]['passing_grade']);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Detail Peserta Ujian</title>
    <link rel="shortcut icon" href="<?= base_url() ?>/assets/img/logo.png" />

    <!-- Custom fonts for this template-->
    <link href="<?= base_url('assets/'); ?>vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="<?= base_url('assets/'); ?>css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-gradient-success">

    <div class="container">

        <!-- Outer Row -->
        <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12 col-md-9">
                <div class="card o-hidden border-0 shadow-md my-5">
                    <div class="card-body p-0">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="pb-5 pt-3">
                                    <div class="text-center">
                                        <img src="<?= base_url() ?>/assets/img/logo.png" width="300px" />
                                        <h1 class="h4 text-success mb-4 font-weight-bold">Detail Peserta</h1>
                                    </div>
                                    <div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">Nama Lengkap</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $nama ?></p>
                                            </div>
                                        </div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">No Peserta</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $no_p ?></p>
                                            </div>
                                        </div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">No Handphone</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $no_hp ?></p>
                                            </div>
                                        </div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">Asal Sekolah</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $asal_s ?></p>
                                            </div>
                                        </div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">Nama Ujian</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $nama_ujian ?></p>
                                            </div>
                                        </div>
                                        <div class="row text-bold">
                                            <div class="col-6">
                                                <p class="text-gray-900">Waktu Mulai</p>
                                            </div>
                                            <div class="col-6 row">
                                                <p class="mx-1">:</p>
                                                <p><?= $waktu_mulai ?></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row text-bold">
                                        <div class="col-6">
                                            <p class="text-gray-900">Durasi</p>
                                        </div>
                                        <div class="col-6 row">
                                            <p class="mx-1">:</p>
                                            <p><?= $durasi ?></p>
                                        </div>
                                    </div>
                                    <div class="row text-bold">
                                        <div class="col-6">
                                            <p class="text-gray-900">Nilai Minimum Kelulusan</p>
                                        </div>
                                        <div class="col-6 row">
                                            <p class="mx-1">:</p>
                                            <p><?= $score ?></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center mb-5">
                                    <a class="btn btn-success" href="<?= base_url('peserta/soal') ?>" role="button">Mulai Test</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
	<script>
        localStorage.clear();
    </script>

    <!-- Bootstrap core JavaScript-->
    <script src="<?= base_url('assets/'); ?>vendor/jquery/jquery.min.js"></script>
    <script src="<?= base_url('assets/'); ?>vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="<?= base_url('assets/'); ?>vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>

</body>

</html>
