<?php

namespace App\Http\Controllers;

use App\Models\lotto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use function GuzzleHttp\json_decode;

class LottoController extends Controller
{
    public function lottoAllListStore()
    {

        $i = 1;

        $ch = curl_init();          //curl 초기화

        while (true) {
            $api_url = 'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=' . $i;

            curl_setopt($ch, CURLOPT_URL, $api_url);               //URL 지정하기
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);    //요청 결과를 문자열로 반환
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);      //connection timeout 10초
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);   //원격 서버의 인증서가 유효한지 검사 안함
            $response = curl_exec($ch);
            $response = json_decode($response, true);

            if ($response['returnValue'] == 'fail') {
                break;
            } else {
                $lotto = new lotto();

                $lotto->drwNo = $response['drwNo'];
                $lotto->drwNoDate = $response['drwNoDate'];
                $lotto->totSellamnt = $response['totSellamnt'];
                $lotto->firstWinamnt = $response['firstWinamnt'];
                $lotto->firstPrzwnerCo = $response['firstPrzwnerCo'];
                $lotto->firstAccumamnt = $response['firstAccumamnt'];
                $lotto->drwtNo1 = $response['drwtNo1'];
                $lotto->drwtNo2 = $response['drwtNo2'];
                $lotto->drwtNo3 = $response['drwtNo3'];
                $lotto->drwtNo4 = $response['drwtNo4'];
                $lotto->drwtNo5 = $response['drwtNo5'];
                $lotto->drwtNo6 = $response['drwtNo6'];
                $lotto->bnusNo = $response['bnusNo'];

                $lotto->save();

                $i++;
            }
        }

        curl_close($ch);

        return 'finish';
    }

    public function lottoNewListStore()
    {
        $drwNo = null;

        $res = DB::select('select drwNo from lottos order by drwNo desc limit 1');

        foreach ($res as $result) {
            $drwNo = $result->drwNo + 1;
        }


        $ch = curl_init();          //curl 초기화
        $api_url = 'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=' . $drwNo;

        curl_setopt($ch, CURLOPT_URL, $api_url);               //URL 지정하기
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);    //요청 결과를 문자열로 반환
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);      //connection timeout 10초
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);   //원격 서버의 인증서가 유효한지 검사 안함
        $response = curl_exec($ch);
        $response = json_decode($response, true);

        if ($response['returnValue'] == 'fail') {
        } else {
            $lotto = new lotto();

            $lotto->drwNo = $response['drwNo'];
            $lotto->drwNoDate = $response['drwNoDate'];
            $lotto->totSellamnt = $response['totSellamnt'];
            $lotto->firstWinamnt = $response['firstWinamnt'];
            $lotto->firstPrzwnerCo = $response['firstPrzwnerCo'];
            $lotto->firstAccumamnt = $response['firstAccumamnt'];
            $lotto->drwtNo1 = $response['drwtNo1'];
            $lotto->drwtNo2 = $response['drwtNo2'];
            $lotto->drwtNo3 = $response['drwtNo3'];
            $lotto->drwtNo4 = $response['drwtNo4'];
            $lotto->drwtNo5 = $response['drwtNo5'];
            $lotto->drwtNo6 = $response['drwtNo6'];
            $lotto->bnusNo = $response['bnusNo'];

            $lotto->save();
        }

        curl_close($ch);

        $logPath = "log/newlotto.txt";  //로그위치 지정

        $log_file = fopen($logPath, "a");
        fwrite($log_file, date("Y-m-d", time()) . ' / ' . $drwNo . '회차');
        fclose($log_file);
    }

    public function recentlyData()
    {
        $res = DB::select('select * from lottos order by drwNo desc limit 1');

        return $res;
    }

    public function lottoAllList()
    {
        $res = DB::select('select * from lottos order by drwNo desc');

        return $res;
    }
}
