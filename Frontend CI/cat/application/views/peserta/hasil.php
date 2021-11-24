<?php
setcookie('myJavascriptVar', false);
$no_p = $this->session->userdata('no_peserta');
$score = $this->session->userdata('score');
$hasil = $this->db->query("call get_result_ujian('$no_p')")->result_array();
$this->db->reconnect();
$set_done = $this->db->query("call set_peserta_ujian_done('$no_p')");
$nilai = $hasil[0]['total_nilai'];
$this->session->sess_destroy();
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Hasil Ujian</title>
    <link rel="shortcut icon" href="<?= base_url() ?>/assets/img/logo.png" />


    <!-- Custom fonts for this template-->
    <link href="<?= base_url('assets/'); ?>vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="<?= base_url('assets/'); ?>css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-success">

    <div class="container">

        <!-- Outer Row -->
        <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12 col-md-9">
                <div class="card o-hidden border-0 shadow-md my-5">
                    <div class="card-body p-0">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="p-5 text-center text-gray-900">
                                    <h3 class="text-success">Nilai total anda</h3>
                                    <h1><?= $nilai ?></h1>
                                    <h6>nilai minimum kelulusan : <?= $score ?></h6>
                                    <?php
                                    if (!empty($nilai)) {
                                        if ($nilai >= $score) {
                                    ?>
                                            <h5 class="text-success">Selamat Anda Lulus!</h5>
                                        <?php
                                        } else {
                                        ?>
                                            <h5 class="text-danger">Anda Tidak Lulus!</h5>
                                        <?php
                                        }
                                    } else {
                                        ?>
                                        <h5 class="text-danger">Gagal menampilkan nilai, silahkan hubungi admin</h5>
                                    <?PHP
                                    }
                                    ?>
                                    <a class="btn btn-success btn-sm my-5" href="<?= base_url('auth') ?>" role="button">Kembali Login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="<?= base_url('assets/'); ?>vendor/jquery/jquery.min.js"></script>
    <script src="<?= base_url('assets/'); ?>vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="<?= base_url('assets/'); ?>vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>
    <script>
        localStorage.clear();
    </script>

</body>

</html>
